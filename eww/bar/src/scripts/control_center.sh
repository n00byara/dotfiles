#!/bin/bash

dir_name=$(pwd)
total="$(free -m | grep Mem: | awk '{ print $2 }')"
used="$(free -m | grep Mem: | awk '{ print $3 }')"
free=$(expr $total - $used)

close () {
    echo "$dir_name"
    $(eww close control_center -c "$dir_name")
}

open () {
    $(eww open control_center -c $dir_name)
}

case "$1" in
    "true")
        open
    ;;
    "false")
        close
    ;;
    "total")
        echo $total
    ;;
    "used")
        echo $used
    ;;
    "free")
        echo $free
    ;;
esac


exit