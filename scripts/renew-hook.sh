#!/bin/bash

# $RENEWED_LINEAGE - /etc/letsencrypt/live/example.com
# $RENEWED_DOMAINS - example.com hello.example.com

source "$(pwd)/scripts/common.sh"

declare renew_exec="$(pwd)/renew_exec.sh"
declare ssh_params="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

IFS=' ' read -r -a array <<< "$RENEWED_DOMAINS"

log "Renewing $RENEWED_DOMAINS"

for server in "${array[@]}"
do

    ssh $ssh_params root@$server 'mkdir -p /etc/certs'

    declare src1="$RENEWED_LINEAGE/fullchain.pem"
    declare dest1="root@$server:/etc/certs/fullchain.pem"

    declare src2="$RENEWED_LINEAGE/privkey.pem"
    declare dest2="root@$server:/etc/certs/privkey.pem"

    log "Copying $src1 to $dest1"
    scp $ssh_params $src1 $dest1

    log "Copying $src2 to $dest2"
    scp $ssh_params $src2 $dest2

    log "Executing renew commands on $server"
    ssh $ssh_params root@$server 'bash -s' < $renew_exec

done
