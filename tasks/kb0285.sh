#!/bin/bash

LOCKFILE="$(puppet config print vardir)/state/agent_disabled.lock"

if [ -e "$LOCKFILE" ] 
then
  echo "Puppet agent is disabled"
  cat "$(puppet config print vardir)/state/agent_disabled.lock"
else
  echo "Puppet agent is enabled"
  exit 1
fi
