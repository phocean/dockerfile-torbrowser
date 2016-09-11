FROM debian:stable

MAINTAINER Phocean <jc@phocean.net>

# Set the env variable DEBIAN_FRONTEND to noninteractive
# to change user name: here, at USER instruction at the end of this file and in the "starttb" file (home dir)

ENV DEBIAN_FRONTEND=noninteractive VERSION=6.0.4 HOME=/home/anon


# from jess/iceweasel MAINTAINER Jessica Frazelle <jess@docker.com>
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    sed -i.bak 's/stable main/stable main contrib/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    flashplugin-nonfree \
    iceweasel \
    xz-utils \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

RUN useradd -m -d $HOME anon

WORKDIR $HOME

# Add TOR browser
RUN curl -sSL -o $HOME/tor.tar.xz https://www.torproject.org/dist/torbrowser/$VERSION/tor-browser-linux64-${VERSION}_fr.tar.xz
RUN curl -sSL -o $HOME/tor.tar.xz.asc https://www.torproject.org/dist/torbrowser/$VERSION/tor-browser-linux64-${VERSION}_fr.tar.xz.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290"
RUN gpg --verify $HOME/tor.tar.xz.asc
RUN tar xvf $HOME/tor.tar.xz
RUN rm -f $HOME/tor.tar.xz*
RUN mkdir $HOME/Downloads
RUN chown -R anon:anon $HOME

VOLUME $HOME/Downloads

USER anon

CMD $HOME/tor-browser_fr/Browser/start-tor-browser
