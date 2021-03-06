#!/bin/bash
set -euo pipefail

declare config_dir="$(dirname $(readlink -f $0))"
declare config_file="config.json"

[[ -f "$config_dir/$config_file" ]] && declare config_path="$config_dir/$config_file"
[[ -f "$config_dir/../$config_file" ]] && declare config_path="$config_dir/../$config_file"

declare root_dir=$(dirname "$config_path")

log()
{
    echo "$(date): $1" >> $root_dir/certbot.log
    echo -e "\e[1;32m=>\e[0m \e[1;37m$1\e[0m"
}

error()
{
    echo "$(date): ERROR: $1" >> $root_dir/certbot.log
    echo -e "\e[0;31m=>\e[0m \e[1;37m$1\e[0m"
}

declare api_token=$(cat $config_path | jq -r ".api_token")
declare master_domain=$(cat $config_path | jq -r ".master_domain")

declare content_type="Content-Type: application/json"
declare auth_header="Authorization: Bearer $api_token"
declare api_url="https://api.digitalocean.com/v2/domains/$master_domain/records"

declare tmp_dir="/tmp/do_certbot"
mkdir -p "$tmp_dir"
