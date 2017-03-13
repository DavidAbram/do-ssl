#!/bin/bash

# $RENEWED_LINEAGE - /etc/letsencrypt/live/example.com
# $RENEWED_DOMAINS - example.com hello.example.com

declare base_dir="$(dirname $(readlink -f $0))"
source "$base_dir/upload.sh"

declare params=$(echo "$RENEWED_DOMAINS" | tr " " ",")
upload $RENEWED_LINEAGE $params
