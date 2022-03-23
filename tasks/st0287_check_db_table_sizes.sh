#!/bin/bash
# shellcheck disable=SC2068
# Puppet Task Name: ST0287_Check_DB_Table_Sizes

declare PT_dbname
dbname=$PT_dbname
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

function getdbTables() {
  path=$1
  dbname=$2
  service=$3
  shift 3
  dblist=("$@")

  if [ "$dbname" != 'all' ]; then
    echo "${service} service detected, will continue to run against ${dbname}."
    su - "$service" -s /bin/bash -c "$path -d $dbname -c '\di+;'"
  else
    echo "${service} service detected, will continue to run against ${dblist[*]}."
    for db in ${dblist[@]};
    do
      su - "$service" -s /bin/bash -c "$path -d $db -c '\di+;'"
    done
  fi
}

#Determine if PE or OSP Postgres
if puppet resource service pe-postgresql | grep -q running; then
  postgresservice="pe-postgres"
  if [ -z "$dbname" ]; then
    dbname="pe-puppetdb"
  fi
elif puppet resource service postgresql-* | grep -q running; then
  postgresservice="postgres"
  if [ -z "$dbname" ]; then
    dbname="puppetdb"
  fi
else
  success '{ "status": "success - Node not running pe-postgresql or postgresql service, please select node which is." }'
fi

#Run for the correct environment
  case "${postgresservice}" in
    pe-postgres)
      echo "Found PE-Postgres"
      pedbnames='pe-puppetdb pe-postgres pe-classifier pe-rbac pe-activity pe-orchestrator postgres'
      getdbTables "/opt/puppetlabs/server/bin/psql" "${dbname}" "${postgresservice}" "${pedbnames}"
      ;;
    postgres)
      echo "Found Postgres"
      getdbTables "psql" "${dbname}" "${postgresservice}" "puppetdb"
      ;;
    *)
      fail "Cannot Determine if Puppet Enterprise or Puppet Open Source"
  esac

success '{ "status": "success - Task completed" }'
