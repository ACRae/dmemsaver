#!/bin/sh

set -e

INSTALL_DIR="$HOME/.dmemsaver"
PROFILE_FILE="$HOME/.profile"
SCRIPT_NAME="dmemsaver"

# Ask user if they want to enable auto-export via cron
echo "[?] Do you want to set up automatic backups via cron? (y/n)"
read ans
if [ "$ans" = "y" ]; then
  CRON_CMD="$INSTALL_DIR/$SCRIPT_NAME --export"
  CRON_ENTRY="0 * * * * $CRON_CMD"

  # Check if the cron job already exists
  if crontab -l 2>/dev/null | grep -Fq "$CRON_CMD"; then
    echo "[✓] Cron job already exists. Skipping."
  else
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
    echo "[✓] Cron job added: $CRON_ENTRY"
  fi
else
  echo "[i] Skipping cron setup."
fi
