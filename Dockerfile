FROM ubuntu:bionic

MAINTAINER Phocean <jc@phocean.net>

ENV DEBIAN_FRONTEND=noninteractive \
    VERSION=7.5.6 \
    LANGUAGE=fr \
    HOME=/home/anon \
    GPG_KEY=0x4E2C6E8793298290

WORKDIR $HOME

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    libgtk2.0-0 libxt6 libx11-xcb1 libdbus-glib-1-2 xz-utils curl libcurl4 ca-certificates gnupg dirmngr &&\
    rm -rf /var/lib/apt/lists/* &&\
    export GNUPGHOME="$(mktemp -d)" &&\
    curl -sSL -o tor.tar.xz https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_${LANGUAGE}.tar.xz &&\
    curl -sSL -o tor.tar.xz.asc https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_${LANGUAGE}.tar.xz.asc &&\
    for server in ha.pool.sks-keyservers.net \
              hkp://p80.pool.sks-keyservers.net:80 \
              keyserver.ubuntu.com \
              hkp://keyserver.ubuntu.com:80 \
              pgp.mit.edu; do \
      gpg --batch --keyserver "$server" --recv-keys $GPG_KEY && break || echo "Trying new server..."; \
    done \
    &&\
    gpg --batch --verify tor.tar.xz.asc tor.tar.xz &&\
    tar xvf tor.tar.xz &&\
    rm -rf "$GNUPGHOME" rm -f tor.tar.xz* &&\
    mkdir -p $HOME/Downloads &&\
    useradd -u 1000 anon &&\
    chown -R anon:anon $HOME

VOLUME $HOME/Downloads

USER anon

CMD $HOME/tor-browser_fr/Browser/start-tor-browser
