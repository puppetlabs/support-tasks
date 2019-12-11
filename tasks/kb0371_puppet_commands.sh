#!/bin/bash

#


declare PT_command
command=$PT_command



if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] || [ -e "/etc/default/puppetserver" ] || [ -e "/etc/default/puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "Puppet master node detected"   #Log Line to StdOut for the Console


case $command in
     config_print)
          puppet config print
          ;;
       module_list)
           puppet module list --all
          ;;
     infrastructure_status)
          puppet infrastructure status
          ;;
     tune)
          puppet infrastructure tune
          ;;
esac
else
  echo  "Not a Puppet master node, exiting"

fi
