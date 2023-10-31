#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task to clean a node's certificate
# This can only be run against the Puppet Primary Server.

# Parameters:
#   * agent_certnames - A comma-separated list of agent certificates to clean/remove.

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update
# For cert removal using API https://www.puppet.com/docs/puppet/8/server/http_certificate_clean

# Original code by Nate McCurdy
# https://github.com/natemccurdy/puppet-purge_node

require 'puppet'
require 'open3'
require 'facter'

Puppet.initialize_settings

def pe_primary?
  !Facter.value('pe_build').nil?
end

# This task only works when running against your Puppet CA server, so let's check for that.
# In Puppetserver, that means the configs contain 'certificate-authority-service', uncommented.
# The puppetserver config file differs between PE and open-source puppetserver.
ca_cfg = pe_primary? ? '/etc/puppetlabs/puppetserver/bootstrap.cfg' : '/etc/puppetlabs/puppetserver/services.d/ca.cfg'

if !File.exist?(ca_cfg) || File.readlines(ca_cfg).grep(%r{^[^#].+certificate-authority-service$}).empty?
  puts 'This task can only be run on your certificate authority Puppetserver'
  exit 1
end

# Version 6 and higher use the 'puppetserver' command for cleaning certs
cmd = if Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') >= 0
        ['/opt/puppetlabs/bin/puppetserver', 'ca', 'clean', '--certname']
      else
        ['/opt/puppetlabs/puppet/bin/puppet', 'cert', 'clean']
      end

def clean_cert(agent, cmd)
  stdout, stderr, status = Open3.capture3(*[cmd, agent].flatten)
  {
    stdout: stdout.strip,
    stderr: stderr.strip,
    exit_code: status.exitstatus,
  }
end

deprecation_msg = "This task is deprecated and has been replaced by the certificate clean api, which provides the same functionality.
                   This task will be removed in a future release.  Please see this module's README for more information"
results = {
  deprecation: deprecation_msg
}
agents = ENV['PT_agent_certnames'].split(',')

agents.each do |agent|
  results[agent] = {}

  if agent == Puppet[:certname]
    results[agent][:result] = 'Refusing to remove the Puppet Primary Server certificate'
    next
  end

  output = clean_cert(agent, cmd)
  results[agent][:result] = output[:exit_code].zero? ? 'Certificate removed' : output
end

puts results.to_json

exit(results.values.reject { |v| v == deprecation_msg }.all? { |v| v[:result] == 'Certificate removed' }) ? 0 : 1
