#!/bin/bash

# Creating local repositories from AUR packages
mkdir -p ./temp/aurlocal && cd ./temp

# 1 Build the AUR Packages Locally: Download and build the desired AUR packages (brave-bin and visual-studio-code-bin in this case):

# Brave Browser
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin && makepkg -si --noconfirm
cd ..
mv brave-bin/*.pkg.tar.zst ./aurlocal/
rm -rf ./brave-bin

# Visual Studio Code
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin && makepkg -si --noconfirm
cd ..
mv visual-studio-code-bin/*.pkg.tar.zst ./aurlocal/
rm -rf ./visual-studio-code-bin

# GitHub Desktop
git clone https://aur.archlinux.org/github-desktop-bin.git
cd github-desktop-bin && makepkg -si --noconfirm
cd ..
mv github-desktop-bin/*.pkg.tar.zst ./aurlocal/
rm -rf ./github-desktop-bin


# Dash to Dock
git clone https://aur.archlinux.org/gnome-shell-extension-dash-to-dock.git
cd gnome-shell-extension-dash-to-dock && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-dash-to-dock/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-dash-to-dock


# System Monitor
git clone https://aur.archlinux.org/gnome-shell-extension-system-monitor.git
cd gnome-shell-extension-system-monitor && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-system-monitor/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-system-monitor


# Launch new Instance
git clone https://aur.archlinux.org/gnome-shell-extension-launch-new-instance.git
cd gnome-shell-extension-launch-new-instance && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-launch-new-instance/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-launch-new-instance


# Rounded Window Corners Reborn
git clone https://aur.archlinux.org/gnome-shell-extension-rounded-window-corners-reborn-git.git
cd gnome-shell-extension-rounded-window-corners-reborn-git && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-rounded-window-corners-reborn-git/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-rounded-window-corners-reborn-git


# Tiling Shell
git clone https://aur.archlinux.org/gnome-shell-extension-tilingshell.git
cd gnome-shell-extension-tilingshell && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-tilingshell/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-tilingshell


# Just 
git clone https://aur.archlinux.org/gnome-shell-extension-just-perfection-desktop.git
cd gnome-shell-extension-just-perfection-desktop && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-just-perfection-desktop/*.pkg.tar.zst ./aurlocal/
rm -rf ./gnome-shell-extension-just-perfection-desktop


# 3 Generate a Database for the Repository: Inside the /temp/customrepo directory, generate a repository database:
repo-add ./aurlocal/aurlocal.db.tar.gz ./aurlocal/*.pkg.tar.zst

# 4 Update pacman.conf to Include the Custom Repository: Add your custom repository to archlive/pacman.conf to allow mkarchiso to use it during the image build process:
# [aurlocal]
# SigLevel = Optional TrustAll
# Server = file:///temp/aurlocal
