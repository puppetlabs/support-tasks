#!/bin/bash

# Puppet Task Name:  bash_herd_resolver
# This task is to be run on operating systems using a bash shell
# It will randomise the restart of the puppet agent based on the current value of runinterval

sleep $(( ( RANDOM % $(/opt/puppetlabs/bin/puppet agent --configprint runinterval) )  + 1 ))s
/opt/puppetlabs/bin/puppet resource service puppet ensure=stopped
/opt/puppetlabs/bin/puppet resource service puppet ensure=running
