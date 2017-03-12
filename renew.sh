#!/bin/bash
set -euo pipefail

declare basedir="$(dirname $(readlink -f $0))"
declare renew_hook="$basedir/scripts/renew-hook.sh"

certbot renew --force-renewal --preferred-challenges dns \
--test-cert \
--agree-tos --non-interactive --manual-public-ip-logging-ok \
--renew-hook $renew_hook
