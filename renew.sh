#!/bin/bash
set -euo pipefail

declare base_dir="$(dirname $(readlink -f $0))"
declare renew_hook="$base_dir/scripts/renew-hook.sh"

certbot renew --force-renewal --preferred-challenges dns \
--test-cert \
--agree-tos --non-interactive --manual-public-ip-logging-ok \
--renew-hook $renew_hook
