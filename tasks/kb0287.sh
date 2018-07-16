#!/bin/bash
# Puppet Task Name: KB0287
# shellcheck disable=SC2078

declare PT_dbname
dbname=$PT_dbname

if [ "puppet resource service pe-postgresql | grep running" ]
then
echo "pe-postgresql service detected, will continue to run."

su - pe-postgres -s /bin/bash -c "/opt/puppetlabs/server/bin/psql -d $dbname -c '\di+;'"

else
  echo "Node not running pe-postgresql service, please select node which is."

fi
 echo " -- KB#0287 Task ended: $(date +%s) --"
