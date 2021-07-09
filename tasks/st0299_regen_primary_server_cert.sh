#!/bin/bash
# shellcheck disable=2181
# shellcheck disable=2013
declare PT_dnsaltname_override
CERTNAME="$(puppet config print certname)"
PUPPET_BIN_DIR="/opt/puppetlabs/bin"
PUPPETCMD="${PUPPET_BIN_DIR}/puppet"
PUPPETSERVERCMD="${PUPPET_BIN_DIR}/puppetserver"
PATH="${PUPPET_BIN_DIR}":"${PATH}"

backup_ssl() {
  tar -cvf "/etc/puppetlabs/puppet/ssl_$(date +%Y-%m-%d-%M-%S).tar.gz" /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppetdb/ssl /opt/puppetlabs/server/data/console-services/certs /opt/puppetlabs/server/data/postgresql/9.6/data/certs /etc/puppetlabs/orchestration-services/ssl
}

exit_if_compile_master() {
  grep reverse-proxy-ca-service /etc/puppetlabs/puppetserver/bootstrap.cfg 2>&1 /dev/null
  if [ $? -eq 0 ]; then
    echo "Target server appears to be a PE compile master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
    exit 255
  elif [ $? -eq 2 ]; then
    echo "Target server does not appear to be a PE master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
    exit 255
  fi
}

check_dns_alt_names() {
  if [ "${PUPPET_6}" = true ]; then
    str=$(/opt/puppetlabs/bin/puppetserver ca list --all |grep "${CERTNAME}")
  else
    str=$(puppet cert list "${CERTNAME}")
  fi

  for host in $(grep -oP '(?<="DNS:)(.*?)(?<=")' <<<"${str}"); do
    tmphost="$(echo "${host}"|cut -d'"' -f 1)"
    if [ "$tmphost" == "$CERTNAME" ] || [ "$tmphost" == "puppet" ]
    then
      continue
    fi
    if ! grep "pe_install::puppet_master_dnsaltname.*${tmphost}" /etc/puppetlabs/enterprise/conf.d/pe.conf > /dev/null 2>&1
    then
      echo "'${tmphost}' is set up as a DNS alt name in the existing certificate, but is not present in the 'pe_install::puppet_master_dnsaltnames' setting of '/etc/puppetlabs/enterprise/conf.d/pe.conf'.  Please add it to continue, or use the 'dnsaltname_override' task parameter to skip this check."
      exit 255
    fi
  done
}

# main

puppet_version=$("${PUPPET_BIN_DIR?}/puppet" --version)
if [[ ${puppet_version%%.*} -ge 6 ]];then
  PUPPET_6=true
else
  PUPPET_6=false
fi

exit_if_compile_master

if ! "$PT_dnsaltname_override"
then
  check_dns_alt_names
fi

if [ ! -x $PUPPETCMD ]; then
  echo "Unable to locate executable Puppet command at ${PUPPETCMD}"
  exit 255
fi

# Back up the SSL directories
backup_ssl

rm -f "/opt/puppetlabs/puppet/cache/client_data/catalog/${CERTNAME}.json"

if [ ${PUPPET_6} = true ]; then
  "${PUPPETSERVERCMD}" ca clean --certname "${CERTNAME}"
  find /etc/puppetlabs/puppet/ssl -name "${CERTNAME}".pem -delete
else
  "${PUPPETCMD}" cert clean "${CERTNAME}"
fi

"${PUPPETCMD}" infrastructure configure --no-recover
"${PUPPETCMD}" agent -t

if [ $? -eq 2 ]; then
  exit 0
fi
