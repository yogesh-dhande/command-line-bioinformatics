#!/bin/bash

sudo chmod 666 /var/run/docker.sock

cp sandbox.sh /usr/local/bin
chmod a+x /usr/local/bin/sandbox.sh
usermod -u 1001 -s /usr/local/bin/sandbox.sh testuser
docker build -t sandbox .