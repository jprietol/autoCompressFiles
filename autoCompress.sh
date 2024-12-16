#!/bin/bash

PATH_DESTINY="/home/xtashirox/Projects/organizations"
cd $PATH_DESTINY

GENERAL_FORLDERS=("Videos" "Musica" "Documentos" "Photos" "Otros")
GENERAL_INDEX=4

createFolder(){

    local PATH_INTERN="$PATH_DESTINY/$1"
    if [ ! -d "$PATH_INTERN" ]; then
        #echo "Path does not found"
        mkdir "$PATH_INTERN"
    fi
    return
}

organizedFolder(){

    IFS=$'\n' # Cambiar el delimitador de espacio por una nueva línea
    for i in $(find . -maxdepth 1 -type f -regex ''$2'');
    do
        mv "$i" "$PATH_DESTINY/$1" 
    done
    IFS=' ' # Restaurar el delimitador de espacio por defecto
    return

}

createHistory(){

if [ "compilation.$idx.tar.gz" == "compilation.0.tar.gz" ];then

cat <<EOF >> history.txt
compilation.$1.tar.gz : 
$(find .  -maxdepth 1 -type f  -!  -name "history.txt")


EOF
else

cat <<EOF >> history.txt
compilation.$1.tar.gz : 
$(find .  -maxdepth 1 -type f -! -name "*.tar.gz" -!  -name "history.txt")


EOF
fi

return
}

CompressFiles(){

    local CURRENTFILE=$PATH_DESTINY/$1
    cd $CURRENTFILE
    if [[ ! $(find .  -maxdepth 1 -type f -! -name "*.tar.gz" -!  -name "history.txt") ]];then 
        return
    fi

    local idx=0
    while [ -f "./compilation.$idx.tar.gz" ]
    do
        ((idx++))
    done

    if [ "compilation.$idx.tar.gz" == "compilation.0.tar.gz" ];then
        #Create the first compress file
        createHistory $idx 

        #Create the compress file and Delete the original files after to make the compilation
        find .  -maxdepth 1 -type f  -!  -name "history.txt" | tar -czf compilation.$idx.tar.gz -T - && \
        find .  -maxdepth 1 -type f -! -name "*.tar.gz" -!  -name "history.txt" -exec rm {} \;
        return
    fi

    if [ $(find compilation.$(expr $idx - 1).tar.gz -ctime -7) ];then
        #Create the next files each 7 days
        createHistory $idx 
        find .  -maxdepth 1 -type f -! -name "*.tar.gz" -!  -name "history.txt" | tar -czf compilation.$idx.tar.gz -T -

        #Create the compress file and Delete the original files after to make the compilation
        find .  -maxdepth 1 -type f  -!  -name "history.txt" | tar -czf compilation.$idx.tar.gz -T - && \
        find .  -maxdepth 1 -type f -! -name "*.tar.gz" -!  -name "history.txt" -exec rm {} \;
    fi

    cd $PATH_DESTINY
    return
}


#The script start here
#Creating folders.
for i in ${GENERAL_FORLDERS[@]};
do
    createFolder "$i"
done

#Make the clasificaton and organize the files in each folder
#function [FOLDER] [REGULAR EXPRESION]

organizedFolder "${GENERAL_FORLDERS[0]}" "^\./.*\.\(mp4\|avi\|mov\|mkv\)$" #Move videos files to its correct folder.
organizedFolder "${GENERAL_FORLDERS[1]}" "^\./.*\.\(mp3\|wav\|aac\)$" # Move music files to its correct folder.
organizedFolder "${GENERAL_FORLDERS[2]}" "^\./.*\.\(docx\|txt\|xlsx\|pptx\|odt\|dat\|pdf\)$" # Move documents files to its correct folder.
organizedFolder "${GENERAL_FORLDERS[3]}" "^\./.*\.\(jpg\|png\|jpeg\|giff\|raw\)$" # Move photos files to its correct folder.

if [ -f ./*.* ];then
    mv ./*.* ${GENERAL_FORLDERS[4]}
fi

#If the files have more than 1 week, the shell should compress to save memory space.

CompressFiles "${GENERAL_FORLDERS[0]}" #Compress in the Videos folder
CompressFiles "${GENERAL_FORLDERS[1]}" #Compress in the Music folder
CompressFiles "${GENERAL_FORLDERS[2]}" #Compress in the Documents folder
CompressFiles "${GENERAL_FORLDERS[3]}" #Compress in the Photos folder
CompressFiles "${GENERAL_FORLDERS[4]}" #Compress in the Others folder