#!/bin/bash
# shellcheck disable=SC2230

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update

declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"
task-output "deprecation" "This task is deprecated and will be removed in a future release. Please see this module's README for more information"

if [ -z  "$(facter -p pe_build)" ]
then
	task-succeed "success -  Agent Node Not Proceeding"
fi

if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] # Test to confirm this is a Puppetserver
then

  puppet resource service pe-puppetserver ensure=stopped || task-fail "Could not stop pe-puppetserver"
  $(/usr/bin/which find) /opt/puppetlabs/server/data/puppetserver/filesync/ -type f -name 'index.lock' -delete -print || task-fail "Could not remove lockfile"
  puppet resource service pe-puppetserver ensure=running || task-fail "Could not start pe-puppetserver"
else
  task-succeed "success - pe-puppetserver not installed"
fi

task-succeed "success - filesync lock removed or not present"
