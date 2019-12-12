#!/bin/bash
# shellcheck disable=1117

# Adjust PE services log level

declare PT_loglevel
declare PT_service
loglevel=$PT_loglevel
service=$PT_service

echo "Updating 'pe-${service}' log level to '${loglevel}'"   #Log Line to StdOut for the Console
FACTER_level="${loglevel}" FACTER_service="${service}" puppet apply -e "augeas {'toggle logging level': incl => \"/etc/puppetlabs/$::service/logback.xml\", lens => 'Xml.lns', context => \"/files/etc/puppetlabs/$::service/logback.xml/configuration/root/#attribute\", changes => \"set level \'$::level\'\"}~> service {\"pe-$::service\": ensure => running }"
echo " -- KB#0009 Task ended   $(date +%s) --"
