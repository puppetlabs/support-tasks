#!/bin/bash

#
# shellcheck disable=SC2046

declare PT_command
command=$PT_command



if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ] # Test to confirm this is a Puppetserver
then
  echo "Puppet primary server node detected"   #Log Line to StdOut for the Console


case $command in
     create_role_cd4pe)
          curl -X POST -H 'Content-Type: application/json' --cert $(puppet config print hostcert) --key $(puppet config print hostprivkey) --cacert $(puppet config print localcacert) https://$(hostname -f):4433/rbac-api/v1/roles -d '{"description":"CD4PE user role","display_name":"CD4PE Role","user_ids":[],"group_ids":[],"permissions":[{"object_type":"node_groups","action":"modify_children","instance":"*"},{"object_type":"node_groups","action":"set_environment","instance":"*"},{"object_type":"node_groups","action":"view","instance":"*"},{"object_type":"puppet_agent","action":"run","instance":"*"},{"object_type":"environment","action":"deploy_code","instance":"*"},{"object_type":"nodes","action":"view_data","instance":"*"},{"object_type":"node_groups","action":"edit_config_data","instance":"*"},{"object_type":"orchestrator","action":"view","instance":"*"}]}'
          ;;
       list_tokens)
          su - pe-postgres -s /bin/bash -c "/opt/puppetlabs/server/bin/psql -d pe-rbac -c \"select subjects.login,tokens.expiration FROM subjects LEFT JOIN tokens ON subjects.id = tokens.user_id\"" 
          ;;
  manual_gitlab_webhook_hit)
	  #needs detection of token
          curl -k -v -X POST -H "Content-Type: application/json" "https://$(hostname -f):8170/code-manager/v1/webhook?type=gitlab&token=$(cat ~/.puppetlabs/token)" -d '{ "ref": "refs/heads/production" }'
          ;;
     get_all_services_status)
          SET_SERVER=$(puppet config print server)
	  CONSOLE="${CONSOLE:-$SET_SERVER}"

	curl -X GET \
 	 --tlsv1 \
 	 --cert   $(puppet config print hostcert) \
  	--key    $(puppet config print hostprivkey) \
  	--cacert $(puppet config print localcacert) \
  	https://"${CONSOLE}":4433/status/v1/services | python -m json.tool
	  ;;
esac
else
  echo  "Not a Puppet primary server node, exiting"

fi


