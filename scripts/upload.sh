#!/bin/bash
set -euo pipefail

declare base_dir="$(dirname $(readlink -f $0))"

[[ -f "$base_dir/common.sh" ]] && source "$base_dir/common.sh"
[[ -f "$base_dir/scripts/common.sh" ]] && source "$base_dir/scripts/common.sh"

[[ -f "$base_dir/../renew_exec.sh" ]] && declare renew_exec="$base_dir/../renew_exec.sh"
[[ -f "$base_dir/renew_exec.sh" ]] && declare renew_exec="$base_dir/renew_exec.sh"

upload()
{
    declare lineage=$1
    declare domain_list=$2
    declare ssh_params="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

    declare fullchain="$lineage/fullchain.pem"
    declare privkey="$lineage/privkey.pem"

    IFS=',' read -r -a domains <<< "$domain_list"

    log "Uploading certificates to $domain_list"

    if [ -f $fullchain -a -f $privkey ]
    then
        for domain in "${domains[@]}"
        do
            declare dest_fullchain="root@$domain:/etc/certs/fullchain.pem"
            declare dest_privkey="root@$domain:/etc/certs/privkey.pem"

            ssh $ssh_params root@$domain "mkdir -p /etc/certs"

            log "Copying $fullchain to $dest_fullchain"
            scp $ssh_params $fullchain $dest_fullchain

            log "Copying $privkey to $dest_privkey"
            scp $ssh_params $privkey $dest_privkey

            log "Executing post-renew commands on $domain"
            ssh $ssh_params root@$domain 'bash -s' < $renew_exec || true

        done
    fi
}

