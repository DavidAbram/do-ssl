#!/bin/bash
set -euo pipefail

declare base_dir="$(dirname $(readlink -f $0))"

[[ -f "$base_dir/common.sh" ]] && source "$base_dir/common.sh"
[[ -f "$base_dir/scripts/common.sh" ]] && source "$base_dir/scripts/common.sh"

declare post_exec="$root_dir/post_exec.sh"

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

            declare item=""

            item="/etc/certs on $domain"
            log "Ensuring $item"
            ssh $ssh_params root@$domain "mkdir -p /etc/certs" || error "Unable to ensure $item"

            item="$fullchain to $dest_fullchain"
            log "Copying $item"
            scp $ssh_params $fullchain $dest_fullchain || error "Unable to copy $item"

            item="$privkey to $dest_privkey"
            log "Copying $item"
            scp $ssh_params $privkey $dest_privkey || error "Unable to copy $item"

            item="post-upload commands from $post_exec on $domain"
            log "Executing $item"
            ssh $ssh_params root@$domain 'bash -s' < $post_exec || error "Unable to execute $item"

        done
    else
        error "Cannot find certicates in $lineage"
        exit -1
    fi
}
