#!/bin/bash

echo "Start the script"

PATH_DESTINY="/home/xtashirox/Projects/organizations"
cd $PATH_DESTINY

GENERAL_FORLDERS=("Videos" "Musica" "Documentos" "Otros")
GENERAL_INDEX=3

createFolder(){

    local PATH_INTERN="$PATH_DESTINY/$1"
    #echo "PATH FINAL $PATH_INTER"
    if [ -f "$PATH_INTERN" ]; then
        echo "Path $1 exist ..."
    else
        echo "Path does not found"
        mkdir "$PATH_INTERN"
    fi

}

for i in ${GENERAL_FORLDERS[@]}
do
    createFolder "$i"
done