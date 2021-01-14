#!/bin/bash

# 将PC上指定目录的音乐文件同步到移动硬盘上，同名旧文件不覆盖

if [ ! $1 ]; then
    echo "usage: sh $0 xxx"
    echo "xxx is any input what you like, it is useless"
    exit
fi

# PC默认音乐路径
default_music_path="/d/Download/Music/"
#default_music_path="/d/Github-Project/test"

# 移动硬盘默认音乐路径
mobile_disk_music_path="/e/Music"
#mobile_disk_music_path="/d/Github-Project/test2"

awk -v src="$default_music_path" -v dst="$mobile_disk_music_path" 'BEGIN { cmd="cp -ri "src"/* "dst; print "n" | cmd; }'