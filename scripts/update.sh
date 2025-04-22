#!/bin/sh

INSTALL_DIR="$HOME/.dmemsaver"
REPO_URL="https://github.com/ACRae/dmemsaver.git"

echo "[+] Updating dmemsaver in $INSTALL_DIR..."

if [ -d "$INSTALL_DIR/.git" ]; then
  cd "$INSTALL_DIR" || {
    echo "[!] Failed to enter directory: $INSTALL_DIR"
    exit 1
  }
  git reset --hard HEAD
  git pull origin main || {
    echo "[!] Failed to pull latest changes."
    exit 1
  }
  echo "[✓] dmemsaver successfully updated."
else
  echo "[-] dmemsaver is not a git repository. Re-cloning..."
  rm -rf "$INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR" || {
    echo "[!] Failed to clone repository."
    exit 1
  }
  echo "[✓] Reinstalled dmemsaver from scratch."
fi
