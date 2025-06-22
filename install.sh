#!/usr/bin/env bash

RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
NC='\033[0m'

printf "${GRN}[*]${NC} Installing required packages...\n"
sudo apt update
sudo apt install python3 python3-pip lsb-release figlet jq toilet boxes lolcat

# Determine Linux Distro
# Reference: https://askubuntu.com/a/459425
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && export DISTRO=$UNAME

if [ "$DISTRO" == "Ubuntu" ]; then
    printf "$\n{GRN}[*]${NC} Installing Ubuntu specific packages...\n"
	sudo apt install update-motd update-notifier-common
fi

printf "$\n{GRN}[*]${NC} Installing Python packages...\n"
sudo -H python3 -m pip install -r requirements.txt

printf "$\n{GRN}[*]${NC} Cleanup existing files...\n"
sudo rm -rf /etc/update-motd.d 2>/dev/null
sudo rm -rf /etc/motd 2>/dev/null
sudo rm -rf /etc/motd.dynamic 2>/dev/null

if [ ! -f /etc/default/motd-news ]; then
    printf "$\n{GRN}[*]${NC} Disable motd-news...\n"
    sudo sed -i 's/ENABLED\=1/ENABLED=0/g' /etc/default/motd-news
fi

printf "$\n{GRN}[*]${NC} Create files and directories...\n"
sudo mkdir -m755 /etc/update-motd.d
sudo touch /etc/motd
sudo chmod 644 /etc/motd
sudo chown $USER:$USER /etc/update-motd.d /etc/motd
touch activity.log
chmod 644 activity.log

printf "$\n{GRN}[*]${NC} Copy MOTD files to system...\n"
sudo cp -a ./motd/* /etc/update-motd.d/.
sudo chmod 755 /etc/update-motd.d/*
sudo chmod 644 /etc/update-motd.d/colors.txt

if [ -f /etc/ssh/sshd_config ]; then
    printf "$\n{GRN}[*]${NC} Adjust sshd_config...\n"
    sudo sed -i 's/PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config
fi

if [ ! -f ./config.json ]; then
    printf "$\n{YEL}[!]${NC} Copying default config....\n"
    printf "${YEL}[!]${NC} You should edit this file.\n"
    cp ./config.json.example ./config.json
fi

printf "$\n{GRN}[*]${NC} Finished!\n"
