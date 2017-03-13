#!/bin/bash
set -euo pipefail

declare base_dir="$(dirname $(readlink -f $0))"
source "$base_dir/scripts/common.sh"
source "$base_dir/scripts/upload.sh"

declare auth_hook="$base_dir/scripts/auth-hook.sh"
declare cleanup_hook="$base_dir/scripts/cleanup-hook.sh"
declare domains_list="$base_dir/domains.txt"

log "Generating SSL certificates for $domains_list"

while true
do

    # the loop takes every 100 entries from domains file
    mapfile -t -n 100 domains

    if [ "${#domains[@]}" -gt 0 ]
    then

        declare params=$(IFS=, ; echo "${domains[*]}")
        log "certbot parameter: $params"

        certbot certonly --manual -d $params --preferred-challenges dns \
        --test-cert \
        --agree-tos --noninteractive --manual-public-ip-logging-ok \
        --manual-auth-hook $auth_hook --manual-cleanup-hook $cleanup_hook

        declare lineage="/etc/letsencrypt/live/${domains[0]}"
        upload $lineage $params

    else
        # all domains read
        break
    fi

done < $domains_list

exit 0

