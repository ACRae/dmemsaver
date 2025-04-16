# dmemsaver

📦 **dmemsaver** is a lightweight utility for automatically backing up and restoring emulator save data using a GitHub repository.  
It allows users to **export** game saves to version control and **import** them on other systems with ease — perfect for syncing across devices or just having a backup.

---

## 🚀 Features

- Export save data from multiple emulators to a GitHub repo
- Restore saves based on your current hostname (machine ID)
- Works across systems (as long as emulators are installed)
- Git auto-commit and push support with personal access token
- Cron-friendly for automatic backups
- One-line installer

---

## 📁 Directory Structure
```
. 
├── config.ini # Defines emulator paths and included files 
├── export.py # Exports save files to repo 
├── import.py # Imports save files from repo 
├── script/ 
│ └── setup.sh # Installer script (clones and configures) 
├── dmemsaver # Main CLI entrypoint (bash) 
├── .env # GitHub credentials & repo configuration 
└── README.md
```

---

## ⚙️ Installation

Run this in your terminal (you’ll need `git`, `sh`, and `cron`):

```bash
curl -s https://raw.githubusercontent.com/ACRae/dmemsaver/main/script/install.sh | bash
```

This will:

1. Clone the repo into `~/.dmemsaver`

2. Add the CLI entrypoint (dmemsaver) to your `~/.profile`

3. Optionally set up a cron job for automatic exports



## 🔧 Configuration
`.env`

Create a `.env` file in the root of the repo:
```bash
GIT_USERNAME=your-github-username
GIT_EMAIL=your@email.com
GITHUB_TOKEN=ghp_yourTokenHere
GIT_REPO_URL=https://github.com/yourusername/yoursavegithubrepo.git
GIT_REPO_DIR=dir-to-your-save-repo
```

`.config.ini`
Example config for emulators:

```ini
[retroarch]
path = ~/RetroArch/saves
include = save1.srm, save2.state

[pcsx2]
path = ~/.config/PCSX2/memcards
include = Mcd001.ps2, Mcd002.ps2
```

## 🕹️ Usage
### Export save data:

`dmemsaver --export`

This will:

* Export the files to the local repo (based on hostname)

* Commit + push if changes are detected

### Import save data:

`dmemsaver --import`

This will:

* Copy matching saves (based on hostname) to their respective emulator folders

## 🕒 Automatic Backups

A cron job can be set up via the installation script. It will call:

`dmemsaver --export`

on a regular schedule (e.g., hourly). You can also manually add one:

`crontab -e`

Example entry:

`0 * * * * ~/.dmemsaver/dmemsaver --export`

## 🛠 Requirements

* `sh`

* `python3`

* `git`

* `cron` (for automation)

## 🙌 Contributing

Feel free to fork the project, add your emulator, or open a PR!

## 📜 License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).