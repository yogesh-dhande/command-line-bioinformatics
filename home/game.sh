#!/bin/bash
while :
    do
        PROMPT='Type a command'
        EXPECTED_COMMAND='grep docker sandbox.sh'

        echo ${PROMPT}; echo 

        read COMMAND

        if diff -q <(${COMMAND}) <(${EXPECTED_COMMAND}) > /dev/null
        then 
            echo .......
            echo $(${COMMAND})
            echo .......
            break
        else 
            echo Please try again ...
        fi
        echo
    done
