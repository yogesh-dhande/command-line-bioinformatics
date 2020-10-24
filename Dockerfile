FROM ubuntu:latest

RUN apt-get update && apt-get -y install rsync

COPY home /bin/home

WORKDIR /home

COPY /src/* /bin/

RUN cat /root/.bashrc /bin/.bash-preexec.sh /bin/wrapper.sh > /root/.bashrc