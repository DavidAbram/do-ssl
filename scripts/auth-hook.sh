#!/bin/bash
set -euo pipefail

# $CERTBOT_DOMAIN -> domain that is being validated, i.e. hello.example.com
# $CERTBOT_VALIDATION -> valiation string

declare basedir="$(dirname $(readlink -f $0))"
source "$basedir/common.sh"

# handle root domain case
declare hostname=""
if [ "$CERTBOT_DOMAIN" = "$master_domain" ]
then
    hostname="_acme-challenge"
else
    hostname="_acme-challenge.${CERTBOT_DOMAIN%%.*}"
fi

# run
declare json="{\"type\":\"TXT\",\"name\":\"$hostname\",\"data\":\"$CERTBOT_VALIDATION\"}"
log "Writing TXT for domain $CERTBOT_DOMAIN: Hostname: $hostname, Value: $CERTBOT_VALIDATION"
declare response=$(curl -s -X POST -H "$content_type" -H "$auth_header" -d "$json" "$api_url")
log "DO response: $response"

# save id for cleanup
declare id=$(echo "$response" | jq ".domain_record | .id")
declare id_path="$tmp_dir/id_$CERTBOT_DOMAIN"
echo "$id" > $id_path
log "TXT ID $id was written to $id_path"
