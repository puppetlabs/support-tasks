#!/bin/bash
# shellcheck disable=2181
OLDNAME="$(puppet config print certname)"
HOSTNAME="$(hostname -f)"
PUPPETCMD="/opt/puppetlabs/bin/puppet"
PATH=/opt/puppetlabs/bin:$PATH

setfilecontents() {
  file="${1?}"
  content="${2?}"

  if  [ -e "${file}" ]; then
    echo "${content}" > "${file}"
  fi
}

stopsvc() {
  service="${1?}"

  if ! $PUPPETCMD resource service "$service" ensure=stopped
  then
    echo "Unable to stop '${service}'.  Exiting"
    exit 255
  fi
}

# main

tar -cvf "/etc/puppetlabs/puppet/ssl_$(date +%Y-%m-%d-%M-%S).tar.gz" /etc/puppetlabs/puppet/ssl

grep reverse-proxy-ca-service /etc/puppetlabs/puppetserver/bootstrap.cfg 2>&1 /dev/null
if [ $? -eq 0 ]; then
  echo "Target server appears to be a PE compile master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
  exit 255
elif [ $? -eq 2 ]; then
  echo "Target server does not appear to be a PE master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
  exit 255
fi

if [ ! -x $PUPPETCMD ]; then
  echo "Unable to locate executable Puppet command at ${PUPPETCMD}"
  exit 255
fi

if [ -z "$HOSTNAME" ]; then
  echo "'hostname -f' is returning an empty string.  Perhaps name resolution is not configured?"
  exit 255
fi

if [ "$HOSTNAME" = "$(puppet config print certname)" ]; then
  echo "This script assumes the hostname has already been changed.  The hostname currently matches the certname in puppet.conf.  Exiting."
  exit 255
fi

if ! ping -qc 1 "$HOSTNAME" > /dev/null
then
  echo "The new hostname $HOSTNAME is not pingable.  Make sure name resolution is configured"
  exit 255
fi

for svc in puppet pe-puppetserver pe-activemq mcollective pe-puppetdb pe-postgresql pe-console-services pe-nginx pe-orchestration-services pxp-agent; do
  stopsvc $svc
done

sed -i "s/${OLDNAME}/${HOSTNAME}/g" /etc/puppetlabs/puppet/puppet.conf

sed -i "s/${OLDNAME}/${HOSTNAME}/g" /etc/puppetlabs/enterprise/conf.d/user_data.conf

rm -f /opt/puppetlabs/puppet/cache/client_data/catalog/*

setfilecontents /etc/puppetlabs/nginx/conf.d/proxy.conf ""
setfilecontents /etc/puppetlabs/nginx/conf.d/http_redirect.conf ""
setfilecontents /etc/puppetlabs/puppetdb/certificate-whitelist ""
setfilecontents /etc/puppetlabs/console-services/rbac-certificate-whitelist ""
setfilecontents /etc/puppetlabs/activemq/activemq.xml "<beans></beans>"

$PUPPETCMD infrastructure configure --no-recover
$PUPPETCMD node purge "$OLDNAME"
puppet_version=$("${PUPPET_BIN_DIR?}/puppet" --version)
if [[ ${puppet_version%%.*} -ge 6 ]];then
  find /etc/puppetlabs/puppet/ssl -name "$OLDNAME.pem" -delete
fi
$PUPPETCMD agent -t

if [ $? -eq 2 ]; then
  exit 0
fi
