# 📦 Multi-Platform Media Downloader using Gallery-dl 

**Professional Multi-Platform Media Downloader** – a powerful Windows batch script wrapper for `gallery-dl` featuring an interactive menu, automatic folder management, logging, and cookie support. Download media from Twitter, TikTok, YouTube, Instagram, Reddit, and many more.

![Batch](https://img.shields.io/badge/Windows-Batch_script-0078D6?style=flat&logo=windows&logoColor=white)
![gallery-dl](https://img.shields.io/badge/gallery--dl-powered-4CAF50?style=flat)
![Version](https://img.shields.io/badge/version-2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## ✨ Key Features

- 🎯 **Multi-platform support** – Twitter/X, TikTok, YouTube, Instagram, Reddit, and any site supported by gallery-dl
- 📁 **Auto‑organised folders** – Each platform gets its own subfolder under `Downloads/`
- 🗂️ **Download archive** – Prevents duplicate downloads automatically
- 🍪 **Cookie management** – Enables downloading private content (likes, saved posts, stories)
- 📜 **Session logging** – Every run is logged with safe locale‑independent timestamps
- ⚙️ **Configuration menu** – Reset archives, update gallery-dl, open folders, etc.
- 🖥️ **Clean text UI** – Colour-coded, professional layout with sub‑menus
- 🔁 **Retry & delay** – Built-in `--retries 3 --sleep 2-4` to avoid rate limits

---

## 🚀 Usage

### Prerequisites

1. **Windows** (7, 8, 10, 11)
2. **gallery-dl** installed and available in PATH
   - Install via pip: `pip install gallery-dl`
   - Or download `gallery-dl.exe` from [releases](https://github.com/mikf/gallery-dl/releases) and place it in the same folder (or add to PATH)
3. **Python** (if using pip) – Python 3.7+

### Installation

```bash
git clone https://github.com/username/gallery-dl-ultimate-pro.git
cd gallery-dl-ultimate-pro
# Make sure gallery-dl is available, then run:
Gallery-dl ULTIMATE Pro v2.0.bat

Alternatively, simply place the .bat file anywhere and run it (no admin rights required normally).

First Run
The script will create Downloads, Config, and Logs folders.

Subfolders for each platform are created automatically.

If gallery-dl is not found, an error message is shown and the script exits.

+=========================================================+
:         GALLERY-DL ULTIMATE PRO v2.0                    :
:         Professional Media Downloader                    :
+=========================================================+
:   [1]  Twitter / X Manager                               :
:   [2]  TikTok Manager                                    :
:   [3]  YouTube Manager                                   :
:   [4]  Instagram Manager                                 :
:   [5]  Reddit Manager                                    :
:   [6]  Generic URL Download                              :
:   [S]  Settings and Configuration                        :
:   [L]  View Download Logs                                :
:   [Q]  Exit Program                                      :
+=========================================================+

Example: Twitter Manager
After selecting 1, you will see a sub‑menu:

Photos Only (JPG, PNG)

Videos Only (MP4, MOV)

All Media

Liked Posts (requires cookies)

User Timeline

Twitter List

Simply enter the URL or username, and the script will run gallery-dl with the appropriate parameters.

## 🍪 Cookies (for private content)
Some features (Liked Posts, Stories, Saved Posts) require authentication cookies.

How to set up cookies:

Install the "Get cookies.txt LOCALLY" browser extension (Chrome/Firefox)

Log into your account (Twitter, Instagram, TikTok, etc.)

Export cookies in Netscape format

Save the file as Config\cookies.txt (or place it in the Config folder)

Alternatively, use the Settings → Update / Set Cookie File menu to copy a cookie file from another location.

## 🛠️ Settings Menu
Update / Set Cookie File – Manage cookies.txt

Clear Download Archive – Delete all archive files (force re‑download everything)

Check gallery-dl Version – Show installed version

Update gallery-dl – Run pip install --upgrade gallery-dl

Open Downloads Folder – Open Downloads in Explorer

Open Config Folder – Open Config folder

View Current Configuration – Show summary of paths, arguments, and archive status

## 📂 Auto‑created Folder Structure
Gallery-dl ULTIMATE Pro v2.0/
│
├── Gallery-dl ULTIMATE Pro v2.0.bat
│
├── Downloads/
│   ├── Twitter/
│   │   ├── Liked/
│   │   └── Lists/
│   ├── TikTok/
│   │   ├── Liked/
│   │   └── Tags/
│   ├── YouTube/
│   │   ├── Playlists/
│   │   ├── Channels/
│   │   └── Shorts/
│   ├── Instagram/
│   │   ├── Stories/
│   │   ├── Reels/
│   │   └── Saved/
│   ├── Reddit/
│   │   ├── Subreddits/
│   │   └── Users/
│   └── Other/
│
├── Config/
│   ├── cookies.txt
│   ├── twitter_arch.txt
│   ├── tiktok_arch.txt
│   ├── youtube_arch.txt
│   ├── instagram_arch.txt
│   └── ... (other archive files)
│
└── Logs/
    └── session_20250423_1430.log

## 📜 Logging
Every session is logged to Logs/session_YYYYMMDD_HHMM.log. Logs contain timestamps, download actions, and error messages.

View logs via the View Download Logs menu or by opening the Logs folder directly.

## ⚠️ Important Notes
This script is just a wrapper for gallery-dl. Please respect the gallery-dl license and the terms of service of each platform.

Use responsibly – do not excessively scrape or violate any platform's rules.

Some features (e.g., Instagram Stories) heavily depend on valid cookies and may break if the platform changes its layout.

For gallery-dl specific issues, refer to the official documentation.

## 🤝 Contributing
Feel free to fork, open issues, or submit pull requests. Ideas for improvement:

Support for more platforms (Pixiv, Flickr, DeviantArt)

Simple GUI mode

Integrate yt-dlp for richer YouTube features

Multi‑threaded parallel downloads

## 📄 License
MIT License – free to use and modify. However, you must comply with each platform's terms of service when downloading content.

## 🙏 Credits
gallery-dl – The core engine

###Made with ❤️ for the digital archiving community
