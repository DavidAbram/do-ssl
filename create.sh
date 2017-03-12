#!/bin/bash
set -euo pipefail

cwrite()
{
    echo -e "\e[1;32m=>\e[0m $1"
}

declare basedir="$(dirname $(readlink -f $0))"
declare auth_hook="$basedir/scripts/auth-hook.sh"
declare cleanup_hook="$basedir/scripts/cleanup-hook.sh"
declare domains_list="$basedir/domains.txt"

cwrite "Generating SSL certificates"

while true
do

    # the loop takes every 100 entries from domains file
    mapfile -t -n 100 arr
    (( ${#arr} > 0 )) || break

    declare params=$(IFS=, ; echo "${arr[*]}")
    cwrite "certbot parameter: $params"

    # --test-cert
    # --force-renewal

    certbot certonly --manual -d $params --preferred-challenges dns \
    --test-cert \
    --agree-tos --noninteractive --manual-public-ip-logging-ok \
    --manual-auth-hook $auth_hook --manual-cleanup-hook $cleanup_hook

done < $domains_list

exit 0

