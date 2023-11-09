#!/bin/bash

# Generate Token for requested user, for consumption in other tasks
# shellcheck disable=SC2086

# DEPRECATION:
# This script is now Deprecated and will be removed in a further update
declare PT_user
declare PT_password

echo "This task is deprecated and will be removed in a future release. Please see this module's README for more information"
password=$PT_password
user=$PT_user


printf "%s" "$password" | puppet access login $user --lifetime 1d
