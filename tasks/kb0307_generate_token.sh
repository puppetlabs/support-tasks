#!/bin/bash

# Generate Token for requested user, for consumption in other tasks

declare PT_user
declare PT_password
password=$PT_password
user=$PT_user


printf "$password" | puppet access login $user --lifetime 1d
