#!/bin/bash
# omarchy-wifi-portal — captive-portal sign-in for Omarchy's Wi-Fi widget.
# Clones the stock network widget into your user plugins and patches it.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
stock=/usr/share/omarchy/shell/plugins/panels/network
plugin="$HOME/.config/omarchy/plugins/$(whoami).network"

command -v omarchy >/dev/null || { echo "omarchy not found — this is for Omarchy only."; exit 1; }

# Refuse to patch a widget version we haven't tested against.
if ! (cd "$stock" && sha256sum -c --quiet "$here/upstream.sha256"); then
  echo "Your Omarchy network widget differs from the one this patch targets."
  echo "Not applying. Check github.com/remigius-labs/omarchy-wifi-portal for an update."
  exit 1
fi

if [ -d "$plugin" ]; then
  echo "$plugin already exists — remove it (or run uninstall.sh) first."
  exit 1
fi

omarchy plugin clone omarchy.network
patch -s -d "$plugin" -p1 < "$here/network.patch"
omarchy restart shell

echo "Installed. Behind a captive portal the Wi-Fi icon shows a lock and the"
echo "network row reads 'Sign-in required · click to open portal'."
echo "Test it at home: ./fake-portal.sh on"
