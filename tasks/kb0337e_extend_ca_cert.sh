#!/bin/bash

# shellcheck disable=SC1091
# shellcheck source=files/common.sh
declare PT__installdir
source "$PT__installdir/support_tasks/files/common.sh"

echo "test" | base64 -w 0 - &>/dev/null || fail "base64_test" "This utility requires a version of base64 with the -w flag"

new_cert="$(bash "$PT__installdir/support_tasks/files/kb0337/extend.sh")" || fail "extend_cert"
contents="$(base64 -w 0 "$new_cert")" || fail "encode_cert"

success "{ \"status\": \"success\", \"new_cert\": \"$new_cert\", \"contents\": \"$contents\" }"
