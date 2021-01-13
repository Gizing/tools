#!/bin/bash

if [ $# -ne 3 ]; then
    echo "usage: sh convert_file_encoding.sh dir src_encoding dst_encoding"
    echo "example: sh convert_file_encoding.sh ./ GBK UTF-8"
    exit
fi

function read_dir() 
{
    for file in `ls $1` #注意此处这是两个反引号，表示运行系统命令
    do
        if [ -d $1"/"$file ]; then
            read_dir $1"/"$file
        else
            target=$1"/"$file
            
            iconv -f GBK -t UTF-8 $target > tmp
            if [ $? -ne 0 ]; then
                echo "convert fail file: "$target
            else
                echo "convert succ file: "$target
                mv tmp $target
            fi
        fi
    done
} 

#读取第一个参数
read_dir $1
