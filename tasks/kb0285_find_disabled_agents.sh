#!/bin/bash

LOCKFILE="$(puppet config print statedir)/agent_disabled.lock"

if [ -e "$LOCKFILE" ] 
then
  echo "Puppet agent is disabled"
  cat "$(puppet config print statedir)/agent_disabled.lock"
else
  echo "Puppet agent is enabled"
  exit 1
fi
