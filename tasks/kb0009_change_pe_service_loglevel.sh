!/bin/bash
# shellcheck disable=1117

# Adjust PE services log level

declare PT_loglevel
declare PT_service
loglevel=$PT_loglevel
service=$PT_service

declare -a arrpathstocheck=("/etc/sysconfig/pe-puppetserver" "/etc/default/pe-puppetserver" "/etc/sysconfig/puppetserver" "/etc/default/puppetserver")

function checkpaths(){
  pathsarry=("$@")
    for servin in ${pathsarry[@]}
        do
           if [ -f "$servin" ]; then
              path=$servin
           fi
        done
}

function changeServiceLevel(){

  serv=$1
  echo "Updating '$serv' log level to '${loglevel}'"   #Log Line to StdOut for the Console
  FACTER_level="${loglevel}" FACTER_service="${service}" puppet apply -e "augeas {'toggle logging level': incl => \"/etc/puppetlabs/$::service/logback.xml\", lens => 'Xml.lns', context => \"/files/etc/puppetlabs/$::service/logback.xml/configuration/root/#attribute\", changes => \"set level \'$::level\'\"}~> service {"$serv": ensure => running }"
  echo " -- KB#0009 Task ended   $(date +%s) --"

}

checkpaths "${arrpathstocheck[@]}"

case "${path##*/}" in
   pe-puppetserver)
      echo "Found Puppet Enterprise"
      changeServiceLevel "pe-${service}"
      ;;
   puppetserver)
       echo "Found Opensource"
       changeServiceLevel "${service}"
       ;;
    *)
     echo "Cannot Determine if Puppet Enterprise or Puppet Open Source "
     exit 1
esac