FROM lsiobase/alpine.python:3.6
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	mediainfo && \

# install app
 git clone --depth=1 https://github.com/pymedusa/Medusa /app/medusa

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
