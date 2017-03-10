#!/bin/bash

# $CERTBOT_DOMAIN -> domain that is being validated, i.e. hello.example.com
# $CERTBOT_VALIDATION -> valiation string

source "$(pwd)/common.sh"

# get ID
declare id_path="$tmp/id_$CERTBOT_DOMAIN"
declare id=$(cat $id_path)
log "Deleting TXT with ID $id"

# delete TXT with ID
declare response=$(curl -s -X DELETE -H "$content_type" -H "$auth_header" "$api_url/$id")
log "DO response: $response"

# cleanup
rm $id_path
