set -euo pipefail

log()
{
    echo "$(date): $1" >> certbot.log
}

declare config="config.json"
declare tmp="/tmp/do_certbot"

declare token="$(cat $(pwd)/$config | jq \".do_api_key\")"
declare domain="$(cat $(pwd)/$config | jq \".master_domain\")"

declare ct="Content-Type: application/json"
declare auth="Authorization: Bearer $token"
declare url="https://api.digitalocean.com/v2/domains/$domain/records"

mkdir -p "$tmp"
