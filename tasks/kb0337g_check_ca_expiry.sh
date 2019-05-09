#!/bin/bash

# shellcheck disable=SC1091
# shellcheck source=files/common.sh
declare PT__installdir
source "$PT__installdir/support_tasks/files/common.sh"

cert="${cert:-/etc/puppetlabs/puppet/ssl/certs/ca.pem}"
[[ -e $cert ]] || fail "cert $cert not found"

to_date="${date:-+3 months}"
to_date="$(date --date="$to_date" +"%s")" || fail "Error calculating expiry date"

# Sanity check that we're dealing with a valid cert
PUPPET_BIN='/opt/puppetlabs/puppet/bin'
"${PUPPET_BIN}/openssl" x509 -in "$cert" >/dev/null || fail "error checking $cert"

# The -checkend command in openssl takes a number of seconds as an argument
# However, on older versions we may overflow a 32 bit integer if we use that
# So, we'll use bash arithmetic and `date` to do the comparison
expiry_date="$("${PUPPET_BIN}/openssl" x509 -enddate -noout -in /etc/puppetlabs/puppet/ssl/certs/ca.pem)"
expiry_date="${expiry_date#*=}"
expiry_seconds="$(date --date="$expiry_date" +"%s")" || fail "Error calculating expiry date"

if (( to_date >= expiry_seconds )); then
  success "{ \"status\": \"will expire\", \"expiry date\": \"$expiry_date\" }"
else
  success "{ \"status\": \"valid\", \"expiry date\": \"$expiry_date\" }"
fi
