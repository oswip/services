FROM lscr.io/linuxserver/code-server:latest

RUN apt update -y

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/

RUN apt install -y vim inetutils-ping openssh-client docker-compose-plugin

