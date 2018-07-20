#!/bin/bash
# Puppet Task Name: KB0287_Check_DB_Table_Sizes

declare PT_dbname
dbname=$PT_dbname

if puppet resource service pe-postgresql | grep -q running
then
  if [ "$dbname" != 'all' ]
  then
    echo "pe-postgresql service detected, will continue to run."
    su - pe-postgres -s /bin/bash -c "/opt/puppetlabs/server/bin/psql -d $dbname -c '\di+;'"
  else
    echo "pe-postgresql service detected, will continue to run."
    pedbnames='pe-puppetdb pe-postgres pe-classifier pe-rbac pe-activity pe-orchestrator postgres'
    for pedbnames in $pedbnames
    do
      su - pe-postgres -s /bin/bash -c "/opt/puppetlabs/server/bin/psql -d $pedbnames -c '\di+;'"
    done
  fi
else
  echo "Node not running pe-postgresql service, please select node which is."
fi
  echo " -- KB#0287 Task ended: $(date +%s) --"
