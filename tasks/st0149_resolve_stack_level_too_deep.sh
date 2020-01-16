#!/bin/bash
# shellcheck disable=SC2230


if [ -e "/etc/sysconfig/pe-puppetserver" ] # Test to see if EL-based system
then
 echo "-Puppetmaster node detected - EL "   #Log Line to StdOut for the Console


        if $(/usr/bin/which grep) -q "Xss" /etc/sysconfig/pe-puppetserver
        then  echo "Argument Already  Present"
        else  $(/usr/bin/which sed) -i 's/^\s*\(JAVA_ARGS="\)/JAVA_ARGS="-Xss2m /g' /etc/sysconfig/pe-puppetserver
                puppet resource service pe-puppetserver ensure=stopped
                puppet resource service pe-puppetserver ensure=running
        fi
elif [ -e "/etc/default/pe-puppetserver" ] # cover ubuntu
then
 echo "-Puppetmaster node detected - Ubuntu "   #Log Line to StdOut for the Console


        if $(/usr/bin/which grep) -q "Xss" /etc/default/pe-puppetserver
        then  echo "Argument Already  Present"
        else  $(/usr/bin/which sed) -i 's/^\s*\(JAVA_ARGS="\)/JAVA_ARGS="-Xss2m /g' /etc/default/pe-puppetserver
                puppet resource service pe-puppetserver ensure=stopped
                puppet resource service pe-puppetserver ensure=running
        fi
elif [ -e "/etc/sysconfig/puppetserver" ] # cover OSP EL-based system
then
 echo "-Puppetserver node detected - EL "   #Log Line to StdOut for the Console


        if $(/usr/bin/which grep) -q "Xss" /etc/sysconfig/puppetserver
        then  echo "Argument Already  Present"
        else  $(/usr/bin/which sed) -i 's/^\s*\(JAVA_ARGS="\)/JAVA_ARGS="-Xss2m /g' /etc/sysconfig/puppetserver
                puppet resource service puppetserver ensure=stopped
                puppet resource service puppetserver ensure=running
        fi
elif [ -e "/etc/default/puppetserver" ] # cover ubuntu OSP
then
 echo "-Puppetserver node detected - Ubuntu "   #Log Line to StdOut for the Console


        if $(/usr/bin/which grep) -q "Xss" /etc/default/puppetserver
        then  echo "Argument Already  Present"
        else  $(/usr/bin/which sed) -i 's/^\s*\(JAVA_ARGS="\)/JAVA_ARGS="-Xss2m /g' /etc/default/puppetserver
                puppet resource service puppetserver ensure=stopped
                puppet resource service puppetserver ensure=running
        fi
else
  echo  "-Not a Puppetserver node exiting "

fi
echo " -ST#0149 Task ended   $(date +%s)    --"
