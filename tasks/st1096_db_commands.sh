#!/bin/bash

declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"

PUPPET_BIN='/opt/puppetlabs/puppet/bin'
psql_options=("-d" "$database")

"$PUPPET_BIN/puppet" resource service pe-postgresql | grep -q running || {
  task-fail "pe-postgresql service not found"
}

case "${command?}" in
  resource_events_per_resource)
    query='select certname, containing_class, file, count(*) from resource_events join certnames on certnames.id = resource_events.certname_id group by certname, containing_class, file order by count desc limit 20;'
    psql_options+=("-c" "$query")
    ;;
  longest_resource_titles)
    query='select certname, containing_class, file, resource_title, length(resource_title) from resource_events join certnames on certnames.id = resource_events.certname_id group by certname, containing_class, file, resource_title order by length(resource_title) desc limit 20;'
    psql_options+=("-c" "$query")
    ;;
  postgres_replication_slots)
    query='select * from pg_replication_slots;'
    psql_options+=("-c" "$query")
    ;;
  postgres_replication_status)
    query='select * from pg_stat_replication;'
    psql_options+=("-c" "$query")
    ;;
  postgres_activity)
    query='select * from pg_stat_activity;'
    psql_options+=("-c" "$query")
    ;;
  database_table_sizes)
    query='\d+'
    psql_options+=("-c" "$query")
    ;;
  database_sizes)
    # Hard-coded to pe-puppetdb
    query_file="${_installdir?}/support_tasks/files/db_sizes.sql"
    # To avoid quoting issues, putting complicated queries in files makes sense
    # But, _installdir is created as the --run-as user, so allow pe-postgres to read a copy of the file
    tmp_query="$(mktemp)"; cp "$query_file" "$tmp_query"; chmod 644 "$tmp_query"
    psql_options+=("-f" "$tmp_query")
    ;;
esac

# For better readability, return stdout to the caller instead of trying to munge psql output to json
chmod +r "$_installdir"
runuser -u pe-postgres -- /opt/puppetlabs/server/bin/psql "${psql_options[@]}" || {
  task-fail "Error running query"
}

[[ -e $tmp_query ]] && rm -- "$tmp_query"
# Include a noop so we don't exit 1 if the temp file doesn't exist
:
