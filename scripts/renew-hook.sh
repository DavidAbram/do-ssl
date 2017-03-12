#!/bin/bash

# $RENEWED_LINEAGE - /etc/letsencrypt/live/example.com
# $RENEWED_DOMAINS - example.com hello.example.com

declare remote="$(pwd)/renew_exec.sh"

IFS=' ' read -r -a array <<< "$RENEWED_DOMAINS"

for element in "${array[@]}"
do

    ssh root@$element 'mkdir -p /etc/certs'
    scp $RENEWED_LINEAGE/fullchain.pem root@$element:/etc/certs/
    scp $RENEWED_LINEAGE/privkey.pem root@$element:/etc/certs/
    ssh root@$element 'bash -s' < $remote

done
