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

# Make all .sh scripts in scripts/ executable
echo "[+] Making script files executable..."
find "$INSTALL_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;

# Run bashrc setup script
sh "$INSTALL_DIR/scripts/bashrc.sh"

echo "[✓] Installation complete. Restart your terminal or run:"
echo "  source \"$BASHRC_FILE\""
echo "to start using \`dmemsaver\`."
