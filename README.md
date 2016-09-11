Dockerfile providing TOR browser for anonymous web browsing.

Forked and slightly modified from:

https://github.com/paulczar/docker-torbrowser.git

## Build

```
$ sudo docker build -t phocean/torbrowser .
```

## Run

I recommanded creating an alias to run it with this quite long command:

```bash
alias torbrowser="xhost +local:root && sudo docker run -i -t --rm -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro  -v /tmp/tor:/home/anon/Downloads:Z --device /dev/snd tor-browser && xhost -local:root"
```
