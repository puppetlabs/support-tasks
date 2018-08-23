#!/bin/bash
# Puppet Task Name: kb0298_run_code_deploy

declare PT_environment
environment=$PT_environment

if [ -f "/etc/puppetlabs/puppetserver/conf.d/code-manager.conf" ] 
then
  if [ -f "/root/.puppetlabs/token" ]
  then  
    if [ "$environment" != 'all' ]
    then
      echo "Attempting to deploy environment: $environment."
      /opt/puppetlabs/bin/puppet-code deploy "$environment" --wait -l debug 2>&1
    else
      echo "Attempting to deploy all environments."
      /opt/puppetlabs/bin/puppet-code deploy --all --wait -l debug 2>&1
    fi
  else
    echo "Please follow the documentation here: https://puppet.com/docs/pe/latest/rbac_token_auth_intro.html#generate-a-token-using-puppet-access to create a new token"
    exit 1 
  fi
else
  echo "Node is not a MoM or does not have Code Manager configured, cannot run Task. To enable Code Manager please follow the documentation here: https://puppet.com/docs/pe/latest/code_mgr_config.html "
  exit 1  
fi
