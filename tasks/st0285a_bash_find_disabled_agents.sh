#!/bin/bash

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update

task-output "deprecation" "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
LOCKFILE="$(puppet config print statedir)/agent_disabled.lock"

if [ -e "$LOCKFILE" ] 
then
  echo "Puppet agent is disabled"
  cat "$(puppet config print statedir)/agent_disabled.lock"
else
  echo "Puppet agent is enabled"
  exit 1
fi
