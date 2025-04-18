#!/bin/sh

REPO_URL="https://github.com/ACRae/dmemsaver.git"
INSTALL_DIR="$HOME/.dmemsaver"
PROFILE_FILE="$HOME/.profile"
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

# Add dmemsaver to .profile
if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$PROFILE_FILE"; then
  echo "[+] Adding dmemsaver to $PROFILE_FILE"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$PROFILE_FILE"
  echo "alias dmemsaver=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$PROFILE_FILE"
else
  echo "[✓] dmemsaver already present in $PROFILE_FILE"
fi

echo "[✓] Installation complete. Restart your terminal or run:"
echo "  source \"$PROFILE_FILE\""
echo "to start using \`dmemsaver\`."