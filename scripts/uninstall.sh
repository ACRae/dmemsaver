#!/bin/sh

set -e

INSTALL_DIR="$HOME/.dmemsaver"
PROFILE_FILE="$HOME/.profile"
ALIAS_LINE="alias dmemsaver='$INSTALL_DIR/dmemsaver'"
PATH_LINE="export PATH=\"\$PATH:$INSTALL_DIR\""

echo "[!] This will uninstall dmemsaver and remove all configuration. Continue? [y/N]: \c"
read confirm

case "$confirm" in
  y|Y)
    echo "[+] Uninstalling dmemsaver..."

    # Remove installed files
    if [ -d "$INSTALL_DIR" ]; then
      rm -rf "$INSTALL_DIR"
      echo "[✓] Removed $INSTALL_DIR"
    else
      echo "[!] Install directory not found."
    fi

    # Remove alias and PATH export from profile
    if [ -f "$PROFILE_FILE" ]; then
      grep -v "$ALIAS_LINE" "$PROFILE_FILE" | grep -v "$PATH_LINE" > "$PROFILE_FILE.tmp" && mv "$PROFILE_FILE.tmp" "$PROFILE_FILE"
      echo "[✓] Cleaned up $PROFILE_FILE"
    fi

    # Remove cron job
    crontab -l 2>/dev/null | grep -v "dmemsaver --export" | crontab -
    echo "[✓] Removed cron job (if any)"

    echo "[✓] Uninstall complete!"
    echo "→ You may need to restart your terminal or run: source $PROFILE_FILE"
    ;;
  *)
    echo "[✗] Uninstall canceled."
    ;;
esac
