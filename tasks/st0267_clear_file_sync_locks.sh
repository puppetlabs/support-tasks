#!/bin/bash
# shellcheck disable=SC2230

declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

if [ -z  "$(facter -p pe_build)" ]
then
	success '{ "status": "success -  Agent Node Not Proceeding" }'
fi

if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] # Test to confirm this is a Puppetserver
then

  puppet resource service pe-puppetserver ensure=stopped || fail "Could not stop pe-puppetserver "
  $(/usr/bin/which find) /opt/puppetlabs/server/data/puppetserver/filesync/ -type f -name 'index.lock' -delete -print || fail "Could not remove lockfile"
  puppet resource service pe-puppetserver ensure=running || fail "Could not start pe-puppetserver "
else
  success '{ "status": "success - pe-puppetserver not installed" }'
fi

success '{ "status": "success - filesync lock removed or not present" }'
