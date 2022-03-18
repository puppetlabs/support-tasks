#!/bin/bash
# Puppet Task Name: st0298_run_code_deploy
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"
declare PT_environment
environment=$PT_environment

if [ -f "/etc/puppetlabs/puppetserver/conf.d/code-manager.conf" ] 
then
  if [ -f "/root/.puppetlabs/token" ]
  then  
    if [ "$environment" != 'all' ]
    then
      /opt/puppetlabs/bin/puppet-code deploy "$environment" --wait -l debug 2>&1  || fail "code deploy failed "
    else
      /opt/puppetlabs/bin/puppet-code deploy --all --wait -l debug 2>&1  ||  fail "code deploy failed "
    fi
  else
   fail "Token not available in default location /root/.puppetlabs/token: https://puppet.com/docs/pe/latest/rbac_token_auth_intro.html#generate-a-token-using-puppet-access  "
  fi
else
  fail  "Node is not a Primary or does not have Code Manager configured. To enable Code Manager please follow the documentation here: https://puppet.com/docs/pe/latest/code_mgr_config.html "
fi

    success '{ "status": "success - Code Deploy completed" }'	
