#!/bin/bash

# $CERTBOT_DOMAIN -> domain that is being validated, i.e. hello.example.com
# $CERTBOT_VALIDATION -> valiation string

source "$(pwd)/common.sh"

declare hostname=""

if [ "$CERTBOT_DOMAIN" = "$domain" ]
then
    hostname="_acme-challenge"
else
    hostname="_acme-challenge.${CERTBOT_DOMAIN%%.*}"
fi

declare json="{\"type\":\"TXT\",\"name\":\"$hostname\",\"data\":\"$CERTBOT_VALIDATION\"}"

log "Writing TXT for domain $CERTBOT_DOMAIN: Hostname: $hostname, Value: $CERTBOT_VALIDATION"

# run
declare response=$(curl -s -X POST -H "$ct" -H "$auth" -d "$json" "$url")
log "DO response: $response"

declare id=$(echo "$response" | jq ".domain_record | .id")
declare idpath="$tmp/id_$CERTBOT_DOMAIN"
echo "$id" > $idpath
log "TXT ID $id was written to $idpath"
