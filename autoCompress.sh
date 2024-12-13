#!/bin/bash

echo "Start the script"

PATH_DESTINY="/home/xtashirox/Projects/organizations"
cd $PATH_DESTINY

GENERAL_FORLDERS=("Videos" "Musica" "Documentos" "Otros")
GENERAL_INDEX=3

createFolder(){

    local PATH_INTERN="$PATH_DESTINY/$1"
    #echo "PATH FINAL $PATH_INTERN"
    if [ -d "$PATH_INTERN" ]; then
        echo "Path $1 exist ..."
    else
        #echo "Path does not found"
        mkdir "$PATH_INTERN"
    fi
    return
}

organizedFolder(){

    IFS=$'\n' # Cambiar el delimitador de espacio por una nueva línea
    for i in $(find . -maxdepth 1 -type f -regex ''$2'');
    do
    echo "i: $i y destino : $PATH_DESTINY/$1"
        mv "$i" "$PATH_DESTINY/$1" 
    done
    IFS=' ' # Restaurar el delimitador de espacio por defecto

}

#Creating folders.
for i in ${GENERAL_FORLDERS[@]};
do
    createFolder "$i"
done

#Make the clasificaton and organize the files in each folder
#function [FOLDER] [REGULAR EXPRESION]

organizedFolder "${GENERAL_FORLDERS[0]}" "^\./.*\.\(mp4\|avi\|mov\|mkv\)$" #Move videos files to its correct folder.
organizedFolder "${GENERAL_FORLDERS[1]}" "^\./.*\.\(mp3\|wav\|aac\)$" # Move music files to its correct folder.
organizedFolder "${GENERAL_FORLDERS[2]}" "^\./.*\.\(docx\|txt\|xlsx\|pptx\|odt\|dat\)$" # Move documents files to its correct folder.

if [ -f ./*.* ];then
    mv ./*.* ${GENERAL_FORLDERS[3]}
fi
