#!/opt/puppetlabs/puppet/bin/ruby
require 'puppet'
require 'facter'
require 'json'

puppet_bin_dir = if Facter.value(:osfamily).eql? 'windows'
                   'C:\\"Program Files"\\"Puppet Labs"\\Puppet\\bin\\'
                 else
                   '/opt/puppetlabs/bin/'
                 end

factupload = `#{puppet_bin_dir}puppet facts upload`

puts JSON.pretty_generate(factupload)
