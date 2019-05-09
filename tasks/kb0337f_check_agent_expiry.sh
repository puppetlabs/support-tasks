#!/bin/bash

# shellcheck disable=SC1091
# shellcheck source=files/common.sh
declare PT__installdir
source "$PT__installdir/support_tasks/files/common.sh"
PUPPET_BIN='/opt/puppetlabs/puppet/bin'

valid=()
expired=()

to_date="${date:-+3 months}"
to_date="$(date --date="$to_date" +"%s")" || fail "Error calculating expiry date"

shopt -s nullglob
for f in /etc/puppetlabs/puppet/ssl/ca/signed/*; do
  # The -checkend command in openssl takes a number of seconds as an argument
  # However, on older versions we may overflow a 32 bit integer if we use that
  # So, we'll use bash arithmetic and `date` to do the comparison
  expiry_date="$("${PUPPET_BIN}/openssl" x509 -enddate -noout -in "$f")"
  expiry_date="${expiry_date#*=}"
  expiry_seconds="$(date --date="$expiry_date" +"%s")" || fail "Error calculating expiry date"

  if (( to_date >= expiry_seconds )); then
    expired+=("\"$f\"")
  else
    valid+=("\"$f\"")
  fi
done

# This is ugly, we as of now we don't include jq binaries in Bolt
# As long as there aren't weird characters in certnames it should be ok
(IFS=,; printf '{"valid": [%s], "expiring": [%s]}' "${valid[*]}" "${expired[*]}")

