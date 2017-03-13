#!/bin/bash
set -euo pipefail

# $CERTBOT_DOMAIN -> domain that is being validated, i.e. hello.example.com
# $CERTBOT_VALIDATION -> valiation string

declare base_dir="$(dirname $(readlink -f $0))"
source "$base_dir/common.sh"

declare id_path="$tmp_dir/id_$CERTBOT_DOMAIN"
declare id=$(cat $id_path)

# get ID
log "Deleting TXT with ID $id"
declare response=$(curl -s -X DELETE -H "$content_type" -H "$auth_header" "$api_url/$id")
log "DO response: $response"

# cleanup
rm -rf $id_path
