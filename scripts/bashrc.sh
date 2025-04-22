#!/bin/sh
set -e

INSTALL_DIR="$HOME/.dmemsaver"
BASHRC_FILE="$HOME/.bashrc"
SCRIPT_NAME="dmemsaver"

# Add dmemsaver to .bashrc
if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$BASHRC_FILE"; then
  echo "[+] Adding dmemsaver to $BASHRC_FILE"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$BASHRC_FILE"
  echo "alias dmemsaver=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$BASHRC_FILE"
else
  echo "[✓] dmemsaver already present in $BASHRC_FILE"
fi
