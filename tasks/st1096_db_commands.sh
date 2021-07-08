#!/bin/bash
declare PT_command
declare PT_database
command=$PT_command
database=$PT_database

if [ `ps -acx|grep postgres|wc -l` -gt 1 ]
then
  echo "PostgreSQL service detected."   #Log Line to StdOut for the Console

case $command in
     resource_events_per_resource)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -d pe-puppetdb -c 'select certname, containing_class, file, count(*) from resource_events join certnames on certnames.id = resource_events.certname_id group by certname, containing_class, file order by count desc limit 20;'\""
          ;;
       longest_resource_titles)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -d pe-puppetdb -c 'select certname, containing_class, file, resource_title, length(resource_title) from resource_events join certnames on certnames.id = resource_events.certname_id group by certname, containing_class, file, resource_title order by length(resource_title) desc limit 20;'\""
          ;;
     pdb_service_status)
       QUERY_COMMAND="curl -X GET -H 'Content-Type: application/json' --cacert $(puppet config print cacert) --key $(puppet config print hostprivkey) --cert $(puppet config print hostcert) https://$(puppet config print server):8081/status/v1/services"
          ;;
     postgre_replication_slots)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -c 'select * from pg_replication_slots;'\""
          ;;
    postgre_replication_status)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -c 'select * from pg_stat_replication;'\""
          ;;
    postgre_activities)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -c 'select * from pg_stat_activity;'\""
          ;;
    database_table_sizes)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -d $database -c '\d+'\""
          ;;
    database_sizes)
       QUERY_COMMAND="su - pe-postgres -s /bin/bash -c \"/opt/puppetlabs/server/bin/psql -c 'SELECT pg_database.datname as database_name, pg_database_size(pg_database.datname)/1024/1024 AS size_in_mb FROM pg_database ORDER by size_in_mb DESC;'\""
          ;;
esac

  eval "$QUERY_COMMAND"

else
  echo  "Not a PostgreSQL node, exiting"
fi
