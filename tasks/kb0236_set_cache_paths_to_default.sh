#!/bin/bash
# shellcheck disable=SC2230

if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "Puppet master node detected"   #Log Line to StdOut for the Console
  echo " This task should only be run on an agent, exiting"
  exit 1
elif [ "$(facter kernel)" == 'Windows' ]
then
  echo "Windows node detected. Not appliciable."
  exit 0
fi

manifest=""

if [ "$(puppet config print vardir)" != "/opt/puppetlabs/puppet/cache" ]
then
  echo  " vardir set to $(puppet config print vardir), resetting to the default"
  manifest+=" augeas {'Remove vardir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/vardir' } "
fi
if [ "$(puppet config print statedir)" != "/opt/puppetlabs/puppet/cache/state" ]
then
  echo  " statedir set to $(puppet config print statedir), resetting to the default"
  manifest+=" augeas {'Remove statedir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/statedir' } "
fi
if [ "$(puppet config print rundir)" != "/var/run/puppetlabs" ]
then
  echo  " rundir set to $(puppet config print rundir), resetting to the default"
  manifest+=" augeas {'Remove rundir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/rundir' } "
fi

if [ "$manifest" != "" ]
then
  puppet apply -e "$manifest"
else
    echo "No changes necessary"
fi

echo "KB#0236 Task ended   $(date +%s)    --"
