#!/opt/puppetlabs/puppet/bin/ruby

# Puppet Task to execute the Puppet Enterprise Support Script and upload the result via SFTP.
# This should only be run against the PE Infrastructure Nodes.

require 'json'
require 'open3'

logage = ENV['PT_logage'] || 3
scope  = ENV['PT_scope']  || 'enterprise,etc,log,networking,resources,system'
ticket = ENV['PT_ticket']

def puppet_enterprise_support(logage, scope, ticket)
  command = '/opt/puppetlabs/puppet/bin/puppet'
  command_line = [command, 'enterprise', 'support', '--v3', '--log-age', logage, '--scope', scope, '--ticket', ticket, '--upload'].join(' ')
  stdout, stderr, status = Open3.capture3(command_line)
  {
    stdout:    stdout.strip,
    stderr:    stderr.strip,
    exit_code: status.exitstatus,
  }
end

results = {}
output = puppet_enterprise_support(logage, scope, ticket)

# rubocop:disable Style/ConditionalAssignment
if output[:exit_code].zero? && !output[:stdout].include?('Unable to upload')
  results[:result] = 'PE Support Script Data Uploaded for Puppet via SFTP'
else
  results[:result] = output[:stdout].lines.reject { |line|
    line == "\n" || line.start_with?(' ** Append') || line.start_with?(' ** Saving')
  }.uniq.join("\n")
end

puts results.to_json
exit(output[:exit_code])
