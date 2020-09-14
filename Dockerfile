FROM ubuntu:latest

COPY home/* /home

WORKDIR /home
RUN chmod +x game.sh