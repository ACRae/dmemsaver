#!/bin/bash

set -e

INSTALL_DIR="$HOME/.dmemsaver"
PROFILE_FILE="$HOME/.profile"
CRON_JOB_COMMAND="$INSTALL_DIR/dmemsaver --export"
DEFAULT_INTERVAL="0 * * * *"  # Every hour

if [[ -d "$INSTALL_DIR" ]]; then
  echo "[!] Directory $INSTALL_DIR already exists. Skipping clone..."
else
  cp -a ./ "$INSTALL_DIR"
fi

# Make main script executable
chmod +x "$INSTALL_DIR/dmemsaver"

# Add to .profile if not already present
if ! grep -q "$INSTALL_DIR" "$PROFILE_FILE"; then
  echo "[+] Adding dmemsaver to PATH in $PROFILE_FILE"
  echo "" >> "$PROFILE_FILE"
  echo "# Add dmemsaver to PATH" >> "$PROFILE_FILE"
  echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$PROFILE_FILE"
  echo "alias dmemsaver='$INSTALL_DIR/dmemsaver'" >> "$PROFILE_FILE"
else
  echo "[✓] dmemsaver already added to .profile"
fi

# Set up cron job
echo ""
read -p "[?] Set up automatic exports via cron? [y/N]: " setup_cron

if [[ "$setup_cron" =~ ^[Yy]$ ]]; then
  read -p "[?] Enter cron interval (default: every hour, e.g., '0 * * * *'): " cron_time
  cron_time="${cron_time:-$DEFAULT_INTERVAL}"

  (crontab -l 2>/dev/null; echo "$cron_time cd $INSTALL_DIR && $CRON_JOB_COMMAND >> $HOME/.dmemsaver.log 2>&1") | crontab -
  echo "[✓] Cron job added: $cron_time"
else
  echo "[!] Skipping cron setup."
fi

echo "[✓] Setup complete!"
echo "-> You may need to restart your terminal or run: source ~/.profile"
echo "-> You can now use: dmemsaver --export or --import"
