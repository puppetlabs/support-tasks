#!/bin/bash
# shellcheck disable=SC2230

if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "-Puppetmaster node detected"   #Log Line to StdOut for the Console

  echo "  Removing File Sync locks"
  $(/usr/bin/which find) /opt/puppetlabs/server/data/puppetserver/filesync/ -type f -name 'index.lock' -delete -print
  echo "  Ensuring the Puppetserver service is running"
  puppet resource service pe-puppetserver ensure=running
else
  echo  "-Not a Puppet MASTER node exiting"

fi
echo " -KB#0267 Task ended   $(date +%s)    --"