FROM lsiobase/python:arm64v8-3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDUSA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	mediainfo \
	py-gdbm && \
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
	/app/medusa --strip-components=1

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
