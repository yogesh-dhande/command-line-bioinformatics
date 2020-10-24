#!/bin/bash

source .bash-preexec.sh

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

preexec() { 
        if [ "$1" == "exit" ]; then exit
		elif [ "$1" == "hint" ]; then echo $2
        elif diff -q <(eval $1 2>&1) <(eval $EXPECTED_COMMAND 2>&1) > /dev/null
			then 
                export PROMPT=""
                OUPUT_COLOR=$green
                cecho "Correct!" $OUPUT_COLOR
			else 
				
                OUPUT_COLOR=$red
                cecho "Please try again ..." $OUPUT_COLOR
		fi
		echo
        cecho "Here's the output of your command: " $OUPUT_COLOR
}

precmd() { 
    rsync -r /bin/home/ /home/
    if ! [[ -n ${PROMPT} ]]; then
        
        while IFS=, read PROMPT EXPECTED_COMMAND <&2
        do
            echo
            cecho "$PROMPT : $EXPECTED_COMMAND" $yellow
            break
        done 2< <(shuf /bin/data.csv)
    else
        echo
        cecho "$PROMPT : $EXPECTED_COMMAND" $yellow
    fi
}