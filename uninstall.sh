#!/bin/bash
# omarchy-wifi-portal — switch back to the stock Wi-Fi widget and remove the patched clone.
set -euo pipefail
plugin="$HOME/.config/omarchy/plugins/$(whoami).network"
omarchy plugin enable omarchy.network 2>/dev/null || true
omarchy plugin remove "$(whoami).network" --yes 2>/dev/null || true
rm -rf "$plugin"
omarchy restart shell
echo "Removed. Stock Wi-Fi widget restored."
