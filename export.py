#!/usr/bin/env python3

import os
import subprocess
import configparser
from pathlib import Path
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Export emulator save files to a GitHub repository.")
parser.add_argument("REPO_DIR", type=str, help="Path to the local GitHub repository.")
args = parser.parse_args()

# Load INI config
config = configparser.ConfigParser()
config.read(os.path.expanduser("~/.dmemsaver/config.ini"))

# Get hostname
HOST = os.uname().nodename
REPO_DIR = Path(args.REPO_DIR)  # Get REPO_DIR from command-line argument

# Ensure REPO_DIR exists
if not REPO_DIR.exists():
    print(f"[!] The specified repository directory does not exist: {REPO_DIR}")
    exit(1)

os.makedirs(REPO_DIR, exist_ok=True)
os.chdir(REPO_DIR)

# Process each emulator section
for app_name in config.sections():
    emu_path = Path(os.path.expanduser(config[app_name].get("path", "")))
    include_raw = config[app_name].get("include", "")
    include_paths = [i.strip() for i in include_raw.split(",") if i.strip()]

    if not emu_path.is_dir():
        print(f"Skipping {app_name} (not installed or no data found at {emu_path})")
        continue

    dest_path = REPO_DIR / HOST / app_name
    os.makedirs(dest_path, exist_ok=True)

    print(f"Exporting selected saves for {app_name}...")

    for rel_include in include_paths:
        src = emu_path / rel_include
        dst = dest_path / rel_include

        if not src.exists():
            print(f"  [!] Missing path: {src}")
            continue

        dst.parent.mkdir(parents=True, exist_ok=True)

        rsync_cmd = [
            "rsync",
            "-a",             # archive mode (recursive + preserves permissions)
            "--delete",       # delete files in dst not present in src
            str(src) + ("/" if src.is_dir() else ""),  # ensure trailing slash for dirs
            str(dst)
        ]

        try:
            subprocess.run(rsync_cmd, check=True)
            print(f"  [+] Synced: {src} → {dst}")
        except subprocess.CalledProcessError as e:
            print(f"  [!] rsync failed for {src}: {e}")
