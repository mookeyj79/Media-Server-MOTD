# Media Server MOTD
Dynamic MOTD for Media Servers.

## Features
Quick status updates on login for the following services:

 - Server Identification Banner
 - Server Stats
 - Plex Streams
 - Plex Autoscan Stats
 - Cloudbox Autoscan Stats
 - rTorrent Stats
 - qBittorrent Stats
 - NZBGet Stats
 - SABnzb Stats

## Installation
Copy ``config.json.example`` to ``config.json`` and modify it to your liking and then run the following commands:
```bash
sudo mkdir -m755 /opt/mtod
sudo chown $USER;$USER /opt/motd
git clone https://github.com/mookeyj79/Cloudbox-MOTD.git /opt/motd
cd /opt/motd
sudo ./install.sh
```

## Credits
 - Based on and inspired by https://github.com/ryanleonard1/PlexMOTD
 - Further enhanced by l3uddz https://github.com/Cloudbox/Cloudbox-MOTD