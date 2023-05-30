#!/bin/bash
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

# Puppet Task Name:  bash_herd_resolver
# This task is to be run on operating systems using a bash shell
# It will randomise the restart of the puppet agent based on the current value of runinterval

sleep $(( ( RANDOM % $(/opt/puppetlabs/bin/puppet agent --configprint runinterval) )  + 1 ))s || task-fail "unable to set random sleep interval"
/opt/puppetlabs/bin/puppet resource service puppet ensure=stopped || task-fail "unable stop puppet service"
/opt/puppetlabs/bin/puppet resource service puppet ensure=running || task-fail "unable start puppet service"

task-succeed "success - Agent restarted at random interval"
