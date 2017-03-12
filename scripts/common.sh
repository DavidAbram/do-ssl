#!/bin/bash

log()
{
    echo "$(date): $1" >> certbot.log
}

declare basedir="$(dirname $(readlink -f $0))"
declare config_file="config.json"
declare tmp_dir="/tmp/do_certbot"

declare api_token="$(cat $basedir/../$config_file | jq -r '.api_token')"
declare master_domain="$(cat $basedir/../$config_file | jq -r '.master_domain')"

declare content_type="Content-Type: application/json"
declare auth_header="Authorization: Bearer $api_token"
declare api_url="https://api.digitalocean.com/v2/domains/$master_domain/records"

# ensure tmp dir
mkdir -p "$tmp_dir"
