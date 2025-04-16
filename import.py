#!/usr/bin/env python3

import os
import shutil
import configparser
from pathlib import Path
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Import emulator save files from a GitHub repository.")
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

    # Define the source path from the repo
    src_path = REPO_DIR / HOST / app_name

    if not src_path.is_dir():
        print(f"Skipping {app_name} (no data found at {src_path})")
        continue

    print(f"Importing saves for {app_name}...")

    for rel_include in include_paths:
        src = src_path / rel_include
        dst = emu_path / rel_include

        if not src.exists():
            print(f"  [!] Missing source path: {src}")
            continue

        try:
            # If the source is a directory, copy recursively
            if src.is_dir():
                if not dst.exists():
                    dst.mkdir(parents=True, exist_ok=True)
                shutil.copytree(src, dst, dirs_exist_ok=True)
            else:
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dst)
            print(f"  [+] Copied: {src} → {dst}")
        except Exception as e:
            print(f"  [!] Failed to copy {src}: {e}")
