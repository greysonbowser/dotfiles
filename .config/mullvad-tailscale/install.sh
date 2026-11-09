#!/bin/sh
set -eu
cd "$(dirname "$0")"

install -m 644 -o root -g root mullvad-tailscale.nft /etc/mullvad-tailscale.nft
install -m 644 -o root -g root mullvad-tailscale.service /etc/systemd/system/mullvad-tailscale.service
systemctl daemon-reload
systemctl enable --now mullvad-tailscale.service

HOSTS_LINE='100.106.204.50  searxng.seagull-byzantine.ts.net'
grep -qxF "$HOSTS_LINE" /etc/hosts || echo "$HOSTS_LINE" >> /etc/hosts

echo "Done, check with: systemctl status mullvad-tailscale"
