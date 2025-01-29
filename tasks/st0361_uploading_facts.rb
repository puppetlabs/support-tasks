#!/opt/puppetlabs/puppet/bin/ruby
require 'puppet'
require 'facter'
require 'json'
require 'open3'

path = if Facter.value(:'os.family').eql? 'windows'
         'C:\\"Program Files"\\"Puppet Labs"\\Puppet\\bin\\'
       else
         '/opt/puppetlabs/bin/'
       end

def facts_upload(path)
  stdout, stderr, status = Open3.capture3("#{path}puppet", 'facts', 'upload')
  {
    stdout:    stdout.strip,
  stderr:    stderr.strip,
  exit_code: status.exitstatus,
  }
end

results = {}

if File.exist?('/etc/puppetlabs/puppet/ssl/certs/ca.pem')
  output = facts_upload(path)

  if output[:exit_code].zero?
    puts output[:exit_code]
    results[:result] = 'Facts uploaded successfully'
  else
    results[:result] = output[:stderr].lines.reject { |line|
      line == "\n"
    }.uniq.join("\n")
  end

  puts results.to_json
  exit(output[:exit_code])

else

  results[:result] = 'No Puppetserver configured, facts upload not needed '
  puts results.to_json
  exit(0)

end
