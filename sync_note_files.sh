#!/bin/bash

# 参数1源目录，参数2是目的目录，只同步一层目录下同名的.md文件
if [ $# -ne 2 ]; then
    echo "usage: sh $0 src_path dst_path"
    exit 1
fi

cd "$1" || exit
source_file_list=$(find ./ -name "*.md")
for full_src_file in $source_file_list; do
    src_file=$(echo "$full_src_file" | awk -F '/' '{print $3}')
    full_dst_file=$(find "$2"/ -name "$src_file" -type f)
    if [ -n "$full_dst_file" ]; then
        echo "$src_file" "exist"
        cp "$full_src_file" "$full_dst_file" && echo "cp $src_file succ"
    fi
done
