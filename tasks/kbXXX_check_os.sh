#!/bin/sh

# Reset paths in case the environment has been reset.
PATH=/opt/puppetlabs/puppet/bin:/opt/puppetlabs/server/bin:/usr/local/bin:$PATH

# Initialize variables.
licensed_nodes=0
license_end=0

# Gather filesystem usage information.
puppetdir_usage=$(df $(puppet config print libdir) | awk '{print $5}' | grep -v Use% | cut -d '%' -f 1)
codedir_usage=$(df $(puppet config print codedir) | awk '{print $5}' | grep -v Use% | cut -d '%' -f 1)

# Gather version information.
pe_build=$(facter -p pe_build)
pe_server_version=$(facter -p pe_server_version)
agent_build=$(facter -p aio_agent_build)

# Gather Puppet and PXP agent statuses.
agent_status=$(puppet resource service puppet | grep ensure | cut -d "'" -f2)
pxp_status=$(puppet resource service pxp-agent | grep ensure | cut -d "'" -f2)

# Gather license information if the license file exists.
if [ -f "$(puppet config print confdir)/../license.key" ]; then
  licensed_nodes=$(grep nodes $(puppet config print confdir)/../license.key | cut -d ':' -f 2)
  license_end=$(grep end $(puppet config print confdir)/../license.key | cut -d ':' -f 2)
fi

# Check CA cert expiration date.
cacert_expires=$(openssl x509 -enddate -noout -in $(puppet config print cacert) 2>/dev/null | grep notAfter | cut -d '=' -f2)

# Export the data in json format for parsing in plan.
printf '{"PuppetDirectoryUsage":"%s","CodeDirectoryUsage":"%s","puppet-agent":"%s","pxp-agent":"%s","LicensedNodes":"%s","LicenseEndDate":"%s","pe_build":"%s","pe_server_version":"%s","agent_build":"%s","CAcertExpiration":"%s"}\n' "$puppetdir_usage" "$codedir_usage" "$agent_status" "$pxp_status" "$licensed_nodes" "$license_end" "$pe_build" "$pe_server_version" "$agent_build" "$cacert_expires"

