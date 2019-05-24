#!/usr/bin/env powershell

# Puppet Task Name:powershell_herd_resolver 
#
sleep -s  $(Get-Random -minimum 1 -maximum $(C:\"Program Files"\"Puppet Labs"\Puppet\bin\puppet agent --configprint runinterval))
C:\"Program Files"\"Puppet Labs"\Puppet\bin\puppet resource service puppet ensure=stopped
C:\"Program Files"\"Puppet Labs"\Puppet\bin\puppet resource service puppet ensure=running
