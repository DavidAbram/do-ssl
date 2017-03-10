#!/bin/bash

# $CERTBOT_DOMAIN -> domain that is being validated, i.e. hello.example.com
# $CERTBOT_VALIDATION -> valiation string

source "$(pwd)/common.sh"

# get ID
declare idpath="$tmp/id_$CERTBOT_DOMAIN"
declare id=$(cat $idpath)
log "Deleting TXT with ID $id"

# delete TXT with ID
declare response=$(curl -s -X DELETE -H "$ct" -H "$auth" "$url/$id")
log "DO response: $response"

rm $idpath
