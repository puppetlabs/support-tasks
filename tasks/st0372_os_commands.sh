#!/bin/bash

#

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update

declare PT_command
command=$PT_command


echo "This task is deprecated and will be removed in a future release. Please see this module's README for more information"

if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] || [ -e "/etc/default/puppetserver" ] || [ -e "/etc/sysconfig/puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "Puppetserver node detected"   #Log Line to StdOut for the Console


case $command in
     puppet_port_status)
          netstat -ln | grep '8140\|5432\|8170\|8143\|443 \|4433\|8081\|8150\|8151\|8142'
          ;;
       puppetserver_log)
           tail -100 /var/log/puppetlabs/puppetserver/puppetserver.log
          ;;
  puppetdb_log)
          tail -100 /var/log/puppetlabs/puppetdb/puppetdb.log
          ;;
     console_log)
          tail -100 /var/log/puppetlabs/console-services/console-services.log
          ;;
    orchestrator_log)
          tail -100 /var/log/puppetlabs/orchestration-services/orchestration-services.log
          ;;
  syslog_log)
	  if [ -e "/var/log/messages" ]
	    then
                tail -100 /var/log/messages
	  elif [ -e "/var/log/syslog" ]
            then
               tail -100 /var/log/syslog
	else 
		echo "No default syslog found"
	fi
          ;;
  ssldir_permissions)
          find "$(puppet config print ssldir)" -maxdepth 10 -type d -exec ls -ld "{}" \;
          ;;
esac
else
  echo  "Not a Puppetserver node, exiting"

fi



