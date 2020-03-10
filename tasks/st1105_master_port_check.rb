#!/opt/puppetlabs/puppet/bin/ruby

# st1105_master_port_check
# Checks the port requirements for a puppet master and prints a short description of the port and it's status.
# PE only and this is to be run against the Puppet Master.

require 'socket'
require 'json'

destination = Socket.gethostbyname(Socket.gethostname).first
ports = '8140, 443, 4433, 8081, 8142, 8143, 5432, 8170'
portdesc = {
  '8140' => "The master uses this port to accept inbound traffic/requests from agents.
             The console sends requests to the master on this port. Certificate requests are passed over this port unless ca_port is set differently.
             Puppet Server status checks are sent over this port.",
  '443'  => 'This port provides host access to the console. The console accepts HTTPS traffic from end users on this port.',
  '4433' => 'This port is used as a classifier/console services API endpoint. The master communicates with the console over this port.',
  '8081' => 'PuppetDB accepts traffic/requests on this port. The master and console send traffic to PuppetDB on this port. PuppetDB status checks are sent over this port.',
  '8142' => 'Orchestrator and the Run Puppet button use this port on the master of masters to accept inbound traffic/responses from agents via the Puppet Execution Protocol agent.',
  '8143' => 'Orchestrator uses this port to accept connections from Puppet Communications Protocol brokers to relay communications.
             The orchestrator client also uses this port to communicate with the orchestration services running on the master of masters.
             If you install the client on a workstation, this port must be available on the workstation.',
  '5432' => 'This port is used in a High Availability configuration to replicate data between the master and replica.',
  '8170' => 'Code Manager uses this port to deploy environments, run webhooks, and make API calls.',
}

def port_test(dest, port)
  begin
    Socket.tcp(dest, port, connect_timeout: 5)
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT
    return false
  end
  true
end

results_json = []

ports.split(%r{\s*,\s*}).each do |port_no|
  # If port is open
  result = if port_test(destination, port_no)
             {
               'destination' => destination.to_s,
               'port' => port_no,
               'result' => 'pass',
               'description' => portdesc[port_no],
             }
           # If port is closed
           else
             {
               'destination' => destination.to_s,
               'port' => port_no,
               'result' => 'fail',
               'description' => portdesc[port_no],
             }
           end
  results_json << result
end

puts JSON.pretty_generate(results_json)
