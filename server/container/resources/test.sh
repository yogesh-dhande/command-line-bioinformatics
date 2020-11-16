# !/bin/bash
IFS=""

for i in {0..1}
do 
    command=$(yq -r ".beginner[$i].command" data.yaml)
    clean_up=$(yq -r ".beginner[$i].clean_up" data.yaml)
    prompt=$(yq -r ".beginner[$i].prompt" data.yaml)

    hints=( $(yq -r ".beginner[$i].hints[]" data.yaml ) )
    echo $prompt
    echo $hints
    for elem in "${hints[@]}"
    do
        echo $elem
    done
    eval ${command}
    [[ -n ${clean_up} ]] || eval ${clean_up}

done