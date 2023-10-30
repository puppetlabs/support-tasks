#!/bin/bash
# shellcheck disable=SC2230
# DEPRECATION:
# This script is now Deprecated and will be removed in a further update
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

if [ -n  "$(facter -p pe_build)" ]
then
	task-suceed "***THIS TASK IS NOW DEPRECATED - Please see README*** - success - Not an agent node"
fi

manifest=""
vardir=$(puppet config print vardir) || task-fail "unable to determine vardir"
statedir=$(puppet config print statedir) || task-fail "unable to determine statedir"
rundir=$(puppet config print rundir) || task-fail "unable to determine rundir"

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
  puppet apply -e "$manifest" || task-fail "unable to reset parameters"
  task-succeed "***THIS TASK IS NOW DEPRECATED - Please see README for information*** - success - parameters reset to default"
else
    task-succeed "***THIS TASK IS NOW DEPRECATED - Please see README for information*** - success - No changes necessary"	
fi

