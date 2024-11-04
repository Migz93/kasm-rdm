#!/usr/bin/env bash
set -ex

# Install Remote Desktop Manager from deb
apt-get update
curl -L -o remotedesktopmanager.deb  "https://cdn.devolutions.net/download/Linux/RDM/2024.3.1.2/RemoteDesktopManager_2024.3.1.2_amd64.deb"
apt-get install -y ./remotedesktopmanager.deb
rm remotedesktopmanager.deb

# Desktop icon
cp /usr/share/applications/com.devolutions.remotedesktopmanager.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/com.devolutions.remotedesktopmanager.desktop

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi