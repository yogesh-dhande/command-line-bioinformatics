# !/bin/bash

add () {
    echo $1
    useradd -s /usr/local/bin/sandbox.sh $1
    echo $1 ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$1
    chmod 0440 /etc/sudoers.d/$1
    echo "${1}:${1}" | chpasswd
}

for i in `cat authlist` ; do add $i ; done

