#!/bin/bash

declare logdir
log=$PT_logdir
declare disable_messages
messages=$PT_disable_messages
usleep 100
export "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin""
set -x

usleep 100

echo "Trying to configure the agent service to log to the local6 logging facility"

usleep 100
if /opt/puppetlabs/bin/puppet config set syslogfacility local6; then
usleep 100    
echo "Success!"
else
usleep 100   
 echo "there was an error, check syslog"
exit 1
fi

usleep 100
echo "creating new puppet-agent log at $log"

if ls  "$log/puppet-agent.log"; then
usleep 100
    echo "This file already exists, please check if this has already been configured!"
    
    exit 1
   
else
    usleep 100
    touch "$log/puppet-agent.log"
    echo "done!"
fi



usleep 100
echo "Creating new syslog config"

if ls  "/etc/rsyslog.d/99-puppet-agent.conf"; then
usleep 100
    echo "This file already exists, please check if this has already been configured! exiting"
exit 1

else
usleep 100
touch /etc/rsyslog.d/99-puppet-agent.conf

echo "local6.info                          /var/log/puppetlabs/puppet-agent.log" >> /etc/rsyslog.d/99-puppet-agent.conf

fi


#if this is false then we restart services, 
#if true we disabling logging to messages and restart

if $messages == false; then 
echo "Restarting services"

 puppet resource service rsyslog ensure=stopped ; puppet resource service rsyslog ensure=running ; puppet resource service puppet ensure=stopped ; puppet resource service puppet ensure=running

exit 0

else
sed -i -e 's/*.info;mail.none;authpriv.none;cron.none/*.info;mail.none;authpriv.none;cron.none,local6.none/g' /etc/rsyslog.conf

echo "Restarting services"

puppet resource service rsyslog ensure=stopped ; puppet resource service rsyslog ensure=running ; puppet resource service puppet ensure=stopped ; puppet resource service puppet ensure=running

exit 0
