#!/bin/sh

REPO_URL="https://github.com/ACRae/dmemsaver.git"
INSTALL_DIR="$HOME/.dmemsaver"
BASHRC_FILE="$HOME/.bashrc"
SCRIPT_NAME="dmemsaver"
CRON_INTERVAL="hourly"  # Change to "daily" or "*/30 * * * *" if you want

echo "[+] Cloning dmemsaver into $INSTALL_DIR..."
if [ -d "$INSTALL_DIR" ]; then
  echo "[-] Directory already exists: $INSTALL_DIR"
else
  git clone "$REPO_URL" "$INSTALL_DIR" || {
    echo "[!] Failed to clone repository."
    exit 1
  }
fi

# Add dmemsaver to .bashrc
if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$BASHRC_FILE"; then
  echo "[+] Adding dmemsaver to $BASHRC_FILE"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$BASHRC_FILE"
  echo "alias dmemsaver=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$BASHRC_FILE"
else
  echo "[✓] dmemsaver already present in $BASHRC_FILE"
fi

echo "[✓] Installation complete. Restart your terminal or run:"
echo "  source \"$BASHRC_FILE\""
echo "to start using \`dmemsaver\`."
