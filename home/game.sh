#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
white=$(tput setaf 7)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
yellow=$(tput setaf 3)

reset=`tput sgr0`

cecho() {
  echo "${2}${1}${reset}"
  return
}

cecho "http://example.com" $green

answer="find fastq -name *fastq.* | wc -l"
eval $answer
cat <(find fastq -name *fastq.* | wc -l)

if diff -q <(eval $answer) <(eval "find fastq -name *fastq.* | wc -l") > /dev/null
then 
        echo "success!"
fi

while IFS=, read PROMPT EXPECTED_COMMAND <&2
do
        cecho "$PROMPT" $blue

        while read COMMAND
        do
                if [ "$COMMAND" == "exit" ]; then exit
                elif [ "$COMMAND" == "hint" ]; then echo $EXPECTED_COMMAND


                elif diff -q <(eval $COMMAND) <(eval $EXPECTED_COMMAND) > /dev/null
                    then 
                        cecho "Correct! Here's the output: " $green
                        cecho "-----------------------------------------------------" $yellow
                        cat <(eval $COMMAND)
                        cecho "-----------------------------------------------------" $yellow
                        break
                    else 
                        cecho "Please try again ..." $red
                        cecho "$PROMPT" $blue
                fi
                echo
        done
done 2< <(shuf data.csv)
