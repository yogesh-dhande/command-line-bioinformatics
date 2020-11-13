#!/bin/bash
sudo chmod 666 /var/run/docker.sock
echo $USER
exec docker run -t -i --rm=true --env USERNAME=$USER sandbox
echo shutting down docker