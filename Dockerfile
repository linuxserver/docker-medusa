# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/unrar:latest AS unrar

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDUSA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV LANG='en_US.UTF-8'

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --upgrade --virtual=build-dependencies \
    build-base && \
  echo "**** install packages ****" && \
  apk add -U --update --no-cache \
    ffmpeg \
    mediainfo \
    python3 && \
  echo "**** install app ****" && \
  if [ -z ${MEDUSA_RELEASE+x} ]; then \
    MEDUSA_RELEASE=$(curl -sX GET "https://api.github.com/repos/pymedusa/Medusa/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p \
    /app/medusa && \
  curl -o \
    /tmp/medusa.tar.gz -L \
    "https://github.com/pymedusa/Medusa/archive/${MEDUSA_RELEASE}.tar.gz" && \
  tar xf /tmp/medusa.tar.gz -C \
    /app/medusa --strip-components=1 && \
  cd /app/medusa && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    setuptools \
    wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.22/ -r requirements.txt && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** clean up ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    $HOME/.cache \
    /tmp/*

# copy local files
COPY root/ /

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

# ports and volumes
EXPOSE 8081
VOLUME /config
