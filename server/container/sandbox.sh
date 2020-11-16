#!/bin/bash
sudo chmod 666 /var/run/docker.sock
exec docker run -t -i --rm=true sandbox
echo shutting down docker