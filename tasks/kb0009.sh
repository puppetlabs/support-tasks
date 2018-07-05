#!/bin/sh

# Puppet Task Name: 
#
# This is where you put the shell code for your task.
#
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#
# Puppet tasks make it easy for you to enable others to use your script. Tasks
# describe what it does, explains parameters and which are required or optional,
# as well as validates parameter type. For examples, if parameter "instances"
# must be an integer and the optional "datacenter" parameter must be one of
# portland, sydney, belfast or singapore then the .json file
# would include:
#   "parameters": {
#     "instances": {
#       "description": "Number of instances to create",
#       "type": "Integer"
#     },
#     "datacenter": {
#       "description": "Datacenter where instances will be created",
#       "type": "Enum[portland, sydney, belfast, singapore]"
#     }
#   }
# Learn more at: https://puppet.com/docs/bolt/0.x/writing_tasks.html#ariaid-title11
#
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
