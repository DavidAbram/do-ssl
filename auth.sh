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
declare hostname=""

if [ "$CERTBOT_DOMAIN" = "$domain" ]
then
    hostname="_acme-challenge"
else
    hostname="_acme-challenge.${CERTBOT_DOMAIN%%.*}"
fi

declare url="https://api.digitalocean.com/v2/domains/$domain/records"
declare value="$CERTBOT_VALIDATION"
declare json="{\"type\":\"TXT\",\"name\":\"$hostname\",\"data\":\"$value\"}"

log "Writing TXT for domain $CERTBOT_DOMAIN: Hostname: $hostname, Value: $value"

# run
declare response=$(curl -s -X POST -H "$ct" -H "$auth" -d "$json" "$url")
log "DO response: $response"

declare id=$(echo "$response" | jq ".domain_record | .id")
declare idpath="$tmp/id_$CERTBOT_DOMAIN"
echo "$id" > $idpath
log "TXT ID $id was written to $idpath"
