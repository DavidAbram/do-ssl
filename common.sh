set -euo pipefail

log()
{
    echo "$(date): $1" >> certbot.log
}

declare config_file="config.json"
declare tmp_dir="/tmp/do_certbot"

declare api_token="$(cat $(pwd)/$config | jq \".api_token\")"
declare master_domain="$(cat $(pwd)/$config | jq \".master_domain\")"

declare content_type="Content-Type: application/json"
declare auth_header="Authorization: Bearer $api_token"
declare api_url="https://api.digitalocean.com/v2/domains/$master_domain/records"

# ensure tmp dir
mkdir -p "$tmp"
