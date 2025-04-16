#!/bin/sh
set -e

INSTALL_DIR="$HOME/.dmemsaver"
PROFILE_FILE="$HOME/.profile"
SCRIPT_NAME="dmemsaver"


# Add dmemsaver to .profile
if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$PROFILE_FILE"; then
  echo "[+] Adding dmemsaver to $PROFILE_FILE"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$PROFILE_FILE"
  echo "alias dmemsaver=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$PROFILE_FILE"
else
  echo "[✓] dmemsaver already present in $PROFILE_FILE"
fi