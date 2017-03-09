#!/bin/bash

set -euo pipefail

log()
{
    echo "$(date): $1" >> certbot.log
}

declare token="<set DigitalOcean API token here>"
declare domain="<set parent domain here>"

declare tmp="/tmp/do_certbot"
mkdir -p "$tmp"

declare ct="Content-Type: application/json"
declare auth="Authorization: Bearer $token"
declare url="https://api.digitalocean.com/v2/domains/$domain/records"

# get ID
declare idpath="$tmp/id_$CERTBOT_DOMAIN"
declare id=$(cat $idpath)
log "Deleting TXT with ID $id"

# delete TXT with ID
declare response=$(curl -s -X DELETE -H "$ct" -H "$auth" "$url/$id")
log "DO response: $response"
