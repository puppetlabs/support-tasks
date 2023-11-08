#!/bin/bash

LOCKFILE="$(puppet config print statedir)/agent_disabled.lock"

echo "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
if [ -e "$LOCKFILE" ] 
then
  echo "Puppet agent is disabled"
  cat "$(puppet config print statedir)/agent_disabled.lock"
else
  echo "Puppet agent is enabled"
  exit 1
fi
