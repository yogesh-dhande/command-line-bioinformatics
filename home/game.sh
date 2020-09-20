#!/bin/bash

while :
do 
        LINE=$(shuf -n 1 home/data.csv)

        PROMPT=$(echo $LINE | cut -d "," -f 1 )
        EXPECTED_COMMAND=$(echo $LINE | cut -d "," -f 2 )

        while :
            do
                echo $PROMPT 

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
done
