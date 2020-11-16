# /bin/bash
IFS=$'\n'

[ -z ${HOME_DIR_PATH+x} ] && export HOME_DIR_PATH=resources/home

cd ${HOME_DIR_PATH}

[ -z ${SOURCE_FOLDER_PATH+x} ] && export SOURCE_FOLDER_PATH=..

DATA_FILE=$SOURCE_FOLDER_PATH/data.yaml

ALL_COMMANDS_FILE=$SOURCE_FOLDER_PATH/all_commands
SUMMARY_FILE=$SOURCE_FOLDER_PATH/summary.md
CACHE_DIR=$SOURCE_FOLDER_PATH/cache

i=0

cache() {
    filename=$(echo -n $1 | sha1sum | awk '{print $1}')
    eval ${1} > $CACHE_DIR/$filename
    echo $filename


    echo "###" $((i+1)). $(yq -r ".beginner[${i}].prompt" $DATA_FILE)  >> $SUMMARY_FILE

    echo \`\`\`bash >> $SUMMARY_FILE
    echo $1 >> $SUMMARY_FILE
    echo \`\`\` >> $SUMMARY_FILE

    echo \`\`\` >> $SUMMARY_FILE
    head $CACHE_DIR/$filename >> $SUMMARY_FILE
    echo \`\`\` >> $SUMMARY_FILE
    echo "__________" >> $SUMMARY_FILE
    echo >> $SUMMARY_FILE
    ((i+=1))
}

[ -f $SUMMARY_FILE ] && rm $SUMMARY_FILE

for command in $(yq -r '.beginner[].command' $DATA_FILE)
do  
    [ $command != "null" ] && cache $command

done

echo cached $i commands

yq -r '.beginner[].command' $DATA_FILE > $ALL_COMMANDS_FILE