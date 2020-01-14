#!/bin/bash

# shellcheck disable=SC2230

declare PT_reason
declare PT_puppet_mode

LOCKFILE="$(puppet config print statedir)/agent_disabled.lock"

if [[ $PT_puppet_mode == "enable" ]]
then
  if [ -e "$LOCKFILE" ]
  then
    puppet agent --enable
    echo "enabled puppet on $(puppet config print certname)"
  else
    echo "puppet already enabled on $(puppet config print certname)"
  fi
elif [[ $PT_puppet_mode == "disable" ]]
then
  if [ -e "$LOCKFILE" ]
  then
    echo "puppet daemon already disabled on $(puppet config print certname)"
    cat "$(puppet config print statedir)/agent_disabled.lock"
  else
    puppet agent --disable "$PT_reason"
    echo "disabled puppet on $(puppet config print certname)"
    cat "$(puppet config print statedir)/agent_disabled.lock"
  fi
else
  echo "parameter puppet_mode must be either enable or disable"
  exit 1
fi
