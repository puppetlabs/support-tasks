#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task to purge nodes
# This can only be run against the Puppet Primary Server.

# Parameters:
#   * agent_certnames - A comma-separated list of agent certificate names.

# Original code by Nate McCurdy
# https://github.com/natemccurdy/puppet-purge_node

require 'puppet'
require 'open3'

Puppet.initialize_settings

# This task only works when running against your Puppet CA server, so let's check for that.
# In Puppetserver, that means that the bootstrap.cfg file contains 'certificate-authority-service'.
bootstrap_cfg = '/etc/puppetlabs/puppetserver/bootstrap.cfg'
if !File.exist?(bootstrap_cfg) || File.readlines(bootstrap_cfg).grep(%r{^[^#].+certificate-authority-service$}).empty?
  puts 'This task can only be run on your certificate authority Puppet Primary Server'
  exit 1
end

def purge_node(agent)
  stdout, stderr, status = Open3.capture3('/opt/puppetlabs/puppet/bin/puppet', 'node', 'purge', agent)
  {
    stdout: stdout.strip,
    stderr: stderr.strip,
    exit_code: status.exitstatus,
  }
end

results = {}
agents = ENV['PT_agent_certnames'].split(',')

agents.each do |agent|
  results[agent] = {}

  if agent == Puppet[:certname]
    results[agent][:result] = 'Refusing to purge the Puppet Primary Server'
    next
  end

  output = purge_node(agent)
  results[agent][:result] = output[:exit_code].zero? ? 'Node purged' : output
end

puts results.to_json

exit(results.values.all? { |v| v[:result] == 'Node purged' }) ? 0 : 1
