#!/bin/bash

# Recursively loops through files and if there's a folder, continue down the folder
# args
# $1 -> directory to loop through
# $2 -> files buffer
function walkFolderRecursively() {
    # this is the local list of files
    # files

    # filepath=$1
    # filename=$(basename "$filepath")
    # # echo "File :$filename"
    # # echo "File Name: ${filename%.*}"
    # # echo "File Extension: ${filename##*.}"
    # if [ ${filename##*.} == "java" ]; then
    #     # 
    #     local  __resultvar=$2
    #     eval $__resultvar="'$files'"
    #     return 1;
    # fi
    
    fileCount=0;
    directoryCount=0;
    for file in "$1"/*; do
        # files+=("$file")
        # fileCount=$((fileCount+1))
        filename=$(basename "$file")
        fileType="${filename##*.}"
        # echo "File $file"
        # echo "File Name: ${filename%.*}"
        # echo "File Extension: ${filename##*.}"
        # check if the file path is actually a directory
        if [ -d "$file" ]; then
            # this is a directory - check if there's java files and look deeper
            # we want to loop through but skip anything in the build directory.
            # echo "$filename"
            if [ "$filename" == "build" ]; then
                continue
            fi
            if [ "$filename" == "res" ]; then
                continue
            fi
            if [ "$filename" == "gradle" ]; then
                continue
            fi

            # # if there are java files and we know should look deeper
            # if [ -f "$file"/*.java ]; then
            #     echo "There are java files inside "$file""
            #     continue
            # fi
            directoryCount=$((directoryCount+1));
            walkFolderRecursively "$file" files
        else
            # files+=("$file")
            # echo "$file"
            # this is a file - check the file type, and check if it's a java file
            # if it is - add it to the list and continue
            # filename=$(basename "$file")
            # fileType="${filename##*.}"
            if [ "$fileType" == "java" ]; then
                echo "${file//$DIR/}" >> $WORKING_DIR/out/baseline.txt
                # add the java file to the list of files and continue on your merry way
                files+=("$file")
                continue
            fi
        fi

        # echo "contains java"
        # echo "$(basename "$file")"
        # files+=("$file")
    done
    # echo "Files: $fileCount";
    # echo "Directories: $directoryCount";

    local  __resultvar=$2
    eval $__resultvar="'$files'"

    return 0
}

# working directory
DIR=$1;
WORKING_DIR=`pwd`

# ensures the directory is valid
# check the file to ensure it's valid
if [ ! -d "$DIR" ] ; then
    echo "Directory "$DIR" DOES NOT exists." 
    # exit if directory doesn't exist
    return 0;
else
    mkdir out/
    rm out/baseline.txt
    touch out/baseline.txt
    cd "$DIR"
    # echo "Making baseline file for $DIR"
    # echo "..."

    SECONDS=0
    
    # Walk the file
    walkFolderRecursively "$DIR" files

    duration=$SECONDS
    # echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

    # walkFolder "$DIR" files
    # files
    # echo "${files[@]}"
    # echo "Total java file count ${#files[@]}"
    # echo "Files $files"
fi
