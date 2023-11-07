#!/bin/bash
# Puppet Task Name: st0298_run_code_deploy

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update
declare PT__installdir
source "$PT__installdir/bash_task_helper/files/task_helper.sh"
task-output "deprecation" "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
declare PT_environment
environment=$PT_environment
[ "$environment" == 'all' ] && environment='--all'
failpat='"status": "failed"'
code=/opt/puppetlabs/bin/puppet-code
if [ -f "/etc/puppetlabs/puppetserver/conf.d/code-manager.conf" ] 
then
  if [ -f "/root/.puppetlabs/token" ]
  then  
    output="$("$code" deploy "$environment" --wait -l debug 2>&1)" || \
      task-fail "code deploy failed with exit code $?"
    [[ "${output}" =~ $failpat ]] && task-fail 'code deploy failed'
  else
   task-fail "Token not available in default location /root/.puppetlabs/token: https://puppet.com/docs/pe/latest/rbac_token_auth_intro.html#generate-a-token-using-puppet-access"
  fi
else
  task-fail  "Node is not a Primary or does not have Code Manager configured. To enable Code Manager please follow the documentation here: https://puppet.com/docs/pe/latest/code_mgr_config.html"
fi

    task-succeed "success - Code Deploy completed"