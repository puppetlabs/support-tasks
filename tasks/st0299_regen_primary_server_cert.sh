#!/bin/bash

declare PT__installdir
source "$PT__installdir/support_tasks/files/common.sh"

PUPPET_BIN='/opt/puppetlabs/puppet/bin'
ssldir="$($PUPPET_BIN/puppet config print ssldir)"
cadir="$($PUPPET_BIN/puppet config print cadir)"
certname="$($PUPPET_BIN/puppet config print certname).pem"
# Starting in 2021, the CA directory may or may not be under the ssldir
# Add cadir and ssldir to an array and pass them to find to ensure we delete all necessary files
ca_dirs=("$ssldir" "$cadir")

[[ -d $cadir ]] || fail 'ERROR: could not find cadir.  Please ensure this task is run on the primary Puppet server'

mkdir -p /var/puppetlabs/backups/
cp -aR "$ssldir" /var/puppetlabs/backups || fail "Error backing up ssldir"

find "${ca_dirs[@]}" -name "$certname" -delete
# shellcheck disable=SC2154
PATH="${PATH}:/opt/puppetlabs/bin" puppet infrastructure configure --no-recover &>"$_tmp" || fail "Error running 'puppet infrastructure configure'"

success '{ "status": "success" }'
