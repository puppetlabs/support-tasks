#!/bin/sh
# Task to check the time on Puppet Infrastructure.
# Additionally this task checks to see if server is the Puppet CA.

# Initialize the path in case the shell environment has been reset.
PATH=/opt/puppetlabs/puppet/bin:/opt/puppetlabs/server/bin:/usr/local/bin:$PATH

caServer=$(puppet config print ca_server)
catest=$(puppet config print hostcert | grep $(puppet config print ca_server))
catime=''
mytime=$(date --utc +%s)
if [ -z $catest ];
then
  is_ca='false'
else
  is_ca='true'
  catime=$mytime
fi

# Output in json format
printf '{"CAserver":"%s","mytime":"%s","is_ca":"%s","catime":"%s"}\n' "${caServer}" "${mytime}" "${is_ca}" "${catime}"

echo " -- KB#0XXX check_time task ended   $(date +%s) --"
