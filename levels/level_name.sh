#!/usr/bin/env bash
# This list out all level name from available level in this folder and output it into level_name.txt
# Please run this using Bash. If you are on Windows, install WSL.

shopt -s extglob
file_name="level_name.txt"

for level in *; do
  if [[ "$level" == *.tscn ]]; then
    lvl=${level//[^0-9]/}
    [[ $lvl -lt 10 ]] && lvl="0${lvl}"
    echo "$lvl: $(cat $level | grep "level_name = " | sed 's/level_name = //g;s/\"//g')" >> .tmp
  fi
done

cat .tmp | sort > ${file_name}
rm -f .tmp

less ${file_name}
