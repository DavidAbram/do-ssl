#!/bin/bash

declare auth="$(pwd)/scripts/auth.sh"
declare cleanup="$(pwd)/scripts/cleanup.sh"
declare domains="$(pwd)/scripts/domains.txt"

while true
do

    # the loop takes every 100 entries from domains file

    mapfile -t -n 100 arr
    (( ${#arr} > 0 )) || break

    declare params=$(IFS=, ; echo "${arr[*]}")
    echo "$params"

    # --test-cert
    # --force-renewal 

    certbot certonly --manual -d $params --preferred-challenges dns \
    --test-cert \
    --agree-tos --noninteractive --manual-public-ip-logging-ok \
    --manual-auth-hook $auth --manual-cleanup-hook $cleanup

done < $domains

exit 0

