#!/bin/bash

# Puppet Task Name: KB0244
#
echo " -KB#0244 Task started   $(date +%s)  --"

puppet apply -e "if ($::facts['kernel'] == 'linux') {exec {'Remove MCollective logrotate configuration': command => '/bin/rm /etc/logrotate.d/mcollective',onlyif  => '/bin/test -s /etc/logrotate.d/mcollective',}}"

echo " -KB#0244 Task ended   $(date +%s)    --"
