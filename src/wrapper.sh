#!/bin/bash

DATA_FILE=$SOURCE_FOLDER_PATH/data.yaml
CACHE_DIR=$SOURCE_FOLDER_PATH/cache
TEMP_FILE=/tmp/tempfile

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
    elif [ "$1" == "hint" ]; then echo $2  # TODO

    else
        eval $1 > $TEMP_FILE 2>&1
        CACHE_FILE=$CACHE_DIR/$CACHED_OUTPUT_FILE
        if diff -q $TEMP_FILE $CACHE_FILE > /dev/null
        then 
            ((i+=1))
            OUPUT_COLOR=$green
            cecho "Correct!" $OUPUT_COLOR
        else 
            
            OUPUT_COLOR=$red
            cecho "Please try again ..." $OUPUT_COLOR
        fi
    fi
    echo
    cecho "Here's the output of your command: " $OUPUT_COLOR
    cat $TEMP_FILE
    cecho "Finished printing the output of your command: " $OUPUT_COLOR
    return 1  # prevent execution of the command to save on computation
}

precmd() { 
    rsync -r $SOURCE_FOLDER_PATH/home/ /home/

    # Initialize i if not set
    [ -z ${i+x} ] && export i=0

    EXPECTED_COMMAND=$(yq -r ".beginner[$i].command" $DATA_FILE)
    # CLEAN_UP=$(yq -r ".beginner[$i].clean_up" $DATA_FILE)
    # [[ -n ${CLEAN_UP} ]] || eval ${CLEAN_UP}
    PROMPT=$(yq -r ".beginner[$i].prompt" $DATA_FILE)
    # HINTS=( $(yq -r ".beginner[$i].hints[]" $DATA_FILE ) )

    CACHED_OUTPUT_FILE=$(echo -n $EXPECTED_COMMAND | sha1sum | awk '{print $1}')

    echo
    cecho "$PROMPT : $EXPECTED_COMMAND" $yellow
}


# https://github.com/rcaloras/bash-preexec
source $SOURCE_FOLDER_PATH/.bash-preexec.sh

shopt -s extdebug