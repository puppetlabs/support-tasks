#!/bin/bash
# shellcheck disable=SC2230
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

if [ -n  "$(facter -p pe_build)" ]
then
	success '{ "status": "success - Not an agent node" }'
fi

manifest=""
vardir=$(puppet config print vardir) || fail "unable to determine vardir "
statedir=$(puppet config print statedir) || fail "unable to determine statedir "
rundir=$(puppet config print rundir) || fail "unable to determine rundir "

if [ "$vardir" != "/opt/puppetlabs/puppet/cache" ]
then
  echo  "{ \"vardir\": \"needs reset from $vardir\" }"
  manifest+=" augeas {'Remove vardir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/vardir' } "
fi
if [ "$statedir" != "/opt/puppetlabs/puppet/cache/state" ]
then
  echo  "{ \"statedir\": \"needs reset from $statedir\" }"
  manifest+=" augeas {'Remove statedir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/statedir' } "
fi
if [ "$rundir" != "/var/run/puppetlabs" ]
then
  echo  "{ \"rundir\": \"needs reset from $statedir\" }"
   manifest+=" augeas {'Remove rundir': changes => 'rm etc/puppetlabs/puppet/puppet.conf/main/rundir' } "
fi

if [ "$manifest" != "" ]
then
  puppet apply -e "$manifest" || fail "unable to reset parameters "
  success '{ "status": "success - parameters reset to default" }'
else
    success '{ "status": "success - No changes necessary" }'	
fi

