FROM ubuntu:latest

COPY home /home

WORKDIR /home

COPY /src/* /bin/

RUN cat /root/.bashrc /bin/.bash-preexec.sh /bin/wrapper.sh > /root/.bashrc