#!/bin/bash

# Generate Token for requested user, for consumption in other tasks
# shellcheck disable=SC2086
declare PT_user
declare PT_password
password=$PT_password
user=$PT_user


printf "%s" "$password" | puppet access login $user --lifetime 1d
