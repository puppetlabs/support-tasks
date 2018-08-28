#!/bin/bash
# shellcheck disable=2181
# shellcheck disable=2013
declare PT_dnsaltname_override
CERTNAME="$(puppet config print certname)"
PUPPETCMD="/opt/puppetlabs/bin/puppet"
PATH=/opt/puppetlabs/bin:$PATH

backup_ssl() {
  tar -cvf "/etc/puppetlabs/puppet/ssl_$(date +%Y-%m-%d-%M-%S).tar.gz" /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppetdb/ssl /opt/puppetlabs/server/data/console-services/certs /opt/puppetlabs/server/data/postgresql/9.6/data/certs /etc/puppetlabs/orchestration-services/ssl
}

exit_if_compile_master() {
  grep reverse-proxy-ca-service /etc/puppetlabs/puppetserver/bootstrap.cfg 2>&1 /dev/null
  if [ $? -eq 0 ]; then
    echo "Target server appears to be a PE compile master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
    exit -1
  elif [ $? -eq 2 ]; then
    echo "Target server does not appear to be a PE master.  This script is intended to be targeted only at a PE Master of Masters.  Exiting."
    exit -1
  fi
}

check_dns_alt_names() {
  str=$(puppet cert list "${CERTNAME}")
  
  for host in $(grep -oP '(?<="DNS:)(.*?)(?<=")' <<<"${str}"); do
    tmphost="$(echo "${host}"|cut -d'"' -f 1)"
    if [ "$tmphost" == "$CERTNAME" ] || [ "$tmphost" == "puppet" ]
    then
      continue
    fi
    if ! grep "pe_install::puppet_master_dnsaltname.*${tmphost}" /etc/puppetlabs/enterprise/conf.d/pe.conf > /dev/null 2>&1
    then
      echo "'${tmphost}' is set up as a DNS alt name in the existing certificate, but is not present in the 'pe_install::puppet_master_dnsaltnames' setting of '/etc/puppetlabs/enterprise/conf.d/pe.conf'.  Please add it to continue, or use the 'dnsaltname_override' task parameter to skip this check."
      exit -1
    fi
  done
}

# main

exit_if_compile_master

if ! "$PT_dnsaltname_override"
then
  check_dns_alt_names
fi

if [ ! -x $PUPPETCMD ]; then
  echo "Unable to locate executable Puppet command at ${PUPPETCMD}"
  exit -1
fi

# Back up the SSL directories
backup_ssl

rm -f "/opt/puppetlabs/puppet/cache/client_data/catalog/${CERTNAME}.json"

$PUPPETCMD cert clean "${CERTNAME}"

$PUPPETCMD infrastructure configure --no-recover
$PUPPETCMD agent -t

if [ $? -eq 2 ]; then
  exit 0
fi
