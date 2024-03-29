#!/bin/bash
# shellcheck disable=1117

# Check and Download Latest Z release

declare PT_dlpath
dllocation=$PT_dlpath
family=$(facter -p os.family)
pe=$(facter -p pe_server_version)
majorversion=${pe%.*}
latest=$(curl https://forge.puppet.com/private/versions/pe |  sed -E -e 's/(release")/\n\1/g'  | grep "${majorversion}.x"  |grep -o -P '.{0,0}latest.{0,13}' | awk '{split($0,a,":"); print a[2]}' |  grep -o '".*"' | sed 's/"//g')
echo "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
if [ -e "/etc/sysconfig/pe-puppetserver" ] || [ -e "/etc/default/pe-puppetserver" ];then
        echo "Puppet primary server node detected"   #Log Line to StdOut for the Console
        else
                echo  "Not a Puppet primary server node, exiting"
                exit 0
        fi


 if [ "$pe"  = "$latest" ]; then
               echo "Currently installed Version of Puppet Enterprise $pe ,  is the Latest Release in the $majorversion stream"
             exit 0
           fi



case $family in
     Debian)
          curlfam="ubuntu"
          ;;
       RedHat)
           curlfam="el"
          ;;
     Suse)
          curlfam="sles"
          ;;
     *)
          echo "Not a Supported primary server OS."
          exit 0
          ;;
esac





tarball_name="puppet-enterprise-$latest-$curlfam-$(facter -p os.release.major)-$(facter -p os.architecture).tar.gz"

echo "Downloading PE $latest $curlfam $(facter -p os.release.major) $(facter -p os.architecture)  to: $dllocation/${tarball_name}"
echo

curl \
  -L \
  -o "$dllocation/${tarball_name}" \
  "https://pm.puppetlabs.com/puppet-enterprise/$latest/puppet-enterprise-$latest-$curlfam-$(facter -p os.release.major)-$(facter -p os.architecture).tar.gz"

