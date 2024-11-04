# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BAMBUSTUDIO_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=RemoteDesktopManager \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://play-lh.googleusercontent.com/bzUOTb25ewpckkEKt2fuMsWGWrDauo-qQYj5EgSdzHS0MCT1BVNwZ7fIg_0QP0v0sUE && \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox-esr \
    fonts-dejavu \
    fonts-dejavu-extra \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-qt5 \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    libgstreamer1.0 \
    libgstreamer-plugins-bad1.0 \
    libgstreamer-plugins-base1.0 \
    libosmesa6 \
    libwebkit2gtk-4.0-37 \
    libwx-perl && \
#  echo "**** install bambu studio from appimage ****" && \
#  if [ -z ${BAMBUSTUDIO_VERSION+x} ]; then \
#    BAMBUSTUDIO_VERSION=$(curl -sX GET "https://api.github.com/repos/bambulab/BambuStudio/releases/latest" \
#    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
#  fi && \
#  RELEASE_URL=$(curl -sX GET "https://api.github.com/repos/bambulab/BambuStudio/releases/latest"     | awk '/url/{print $4;exit}' FS='[""]') && \
#  DOWNLOAD_URL=$(curl -sX GET "${RELEASE_URL}" | awk '/browser_download_url.*fedora/{print $4;exit}' FS='[""]') && \
#  cd /tmp && \
#  curl -o \
#    /tmp/bambu.app -L \
#    "${DOWNLOAD_URL}" && \
#  chmod +x /tmp/bambu.app && \
#  ./bambu.app --appimage-extract && \
#  mv squashfs-root /opt/bambustudio && \
  cd /tmp && \
  curl -L -o remotedesktopmanager.deb  "https://cdn.devolutions.net/download/Linux/RDM/2024.3.1.2/RemoteDesktopManager_2024.3.1.2_amd64.deb" && \
  apt-get install -y ./remotedesktopmanager.deb && \
  rm remotedesktopmanager.deb && \
  localedef -i en_GB -f UTF-8 en_GB.UTF-8 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
