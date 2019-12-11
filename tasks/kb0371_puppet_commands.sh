#!/bin/bash

#


declare PT_command
command=$PT_command



if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] || [ -e "/etc/sysconfig/puppetserver" ] || [ -e "/etc/default/puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "Puppetserver node detected"   #Log Line to StdOut for the Console


case $command in
     config_print)
          puppet config print
          ;;
       module_list)
           puppet module list --all
          ;;
     infrastructure_status)
          if [ -e "/etc/sysconfig/puppetserver" ] || [ -e "/etc/default/puppetserver" ]
          then
            echo "Open Source Puppet detected, this command cannot be run"
          else
          puppet infrastructure status
          fi
          ;;
     tune)
          if [ -e "/etc/sysconfig/puppetserver" ] || [ -e "/etc/default/puppetserver" ]
          then
            echo "Open Source Puppet detected, this command cannot be run"
          else
          puppet infrastructure tune
          fi
          ;;
esac
else
  echo  "Not a Puppetserver node, exiting"

fi
