FROM ubuntu:latest

RUN apt-get update && apt-get -y install rsync jq python3-pip && pip3 install yq

ENV SOURCE_FOLDER_PATH=/bin
ENV HOME_DIR_PATH=/home

COPY resources/ $SOURCE_FOLDER_PATH/

COPY resources/home/ ${HOME_DIR_PATH}/

RUN /bin/bash $SOURCE_FOLDER_PATH/cache_commands.sh

WORKDIR ${HOME_DIR_PATH}

RUN cat /root/.bashrc /bin/.bash-preexec.sh /bin/wrapper.sh > /root/.bashrc