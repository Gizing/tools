#!/bin/bash

mkdir pdf_bak
cp ./*.pdf ./pdf_bak/
name_file="./name.txt"

function check_file_num() {
    name_cnt=$(wc -l name.txt | awk '{print $1}')
    echo "name count=""$name_cnt"" in name.txt"
    file_cnt=0
    shopt -s nullglob

    for file in *; do
        result=$(echo "$file" | grep -E "\.pdf$")
        if [ "$result" = "" ]; then
            continue
        fi
        file_cnt=$((file_cnt + 1))
        #echo $file_cnt
    done
    echo "file count=""$file_cnt"
    if [ $file_cnt -eq "$name_cnt" ]; then
        echo "file count match name count in name.txt"
        return
    fi
    echo "error, file count not match name count in name.txt, exit"
    exit
}

#check_file_num

new_name_line=0
file_list=$(ls)
for file in $file_list; do
    #echo $file
    result=$(echo "$file" | grep -E "\.pdf$")
    if [ "$result" = "" ]; then
        continue
    fi
    new_name_line=$((new_name_line + 1))
    new_name=$(sed -n "$new_name_line"p $name_file)
    new_name=$new_name".pdf"

    echo "rename ""$file"" to ""$new_name"
    mv "$file" "$new_name"

done

echo "rename" $new_name_line "files succ"
