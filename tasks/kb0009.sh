#!/bin/bash
# Adjust PE services log level


if [ -e "/etc/sysconfig/pe-puppetserver" ] # Test to see if EL-based system
then
 echo "-Puppetmaster node detected - EL "   #Log Line to StdOut for the Console
 FACTER_level="$PT_loglevel" FACTER_service="$PT_service" puppet apply -e "augeas {'toggle logging level': incl => \"/etc/puppetlabs/$::service/logback.xml\", lens => 'Xml.lns', context => \"/files/etc/puppetlabs/$::service/logback.xml/configuration/root/#attribute\", changes => \"set level \'$::level\'\"}~> service {\"pe-$::service\": ensure => running }"

elif [ -e "/etc/default/pe-puppetserver" ] # cover ubuntu
then
 echo "-Puppetmaster node detected - Ubuntu "   #Log Line to StdOut for the Console
 FACTER_level="$PT_loglevel" FACTER_service="$PT_service" puppet apply -e "augeas {'toggle logging level': incl => \"/etc/puppetlabs/$::service/logback.xml\", lens => 'Xml.lns', context => \"/files/etc/puppetlabs/$::service/logback.xml/configuration/root/#attribute\", changes => \"set level \'$::level\'\"}~> service {\"pe-$::service\": ensure => running }"

else
  echo  "-Not a Puppet MASTER node exiting "

fi
echo " -KB#0009 Task ended   $(date +%s)    --"
