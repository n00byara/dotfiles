#!/bin/bash

dir_name=$(pwd)

close () {
    echo "$dir_name"
    $(eww close control_center -c "$dir_name")
}

open () {
    $(eww open control_center -c $dir_name)
}

# Спиздил из https://github.com/adi1090x/widgets/blob/main/eww/dashboard/scripts/sys_info
cpu() {
    file="/tmp/.cpu_usage"

	if [[ -f "${file}" ]]; then
		file_cont=$(cat "${file}")
		PREV_TOTAL=$(echo "${file_cont}" | head -n 1)
		PREV_IDLE=$(echo "${file_cont}" | tail -n 1)
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${file}"
	echo "${IDLE}" >> "${file}"
}

# Спиздил оттуда же что и проц
ram () {
	FREE_MEMORY=$(free -m | grep Mem | awk '{print ($3/$2)*100}')
	echo $FREE_MEMORY
}

case "$1" in
    "true")
        open
    ;;
    "false")
        close
    ;;
    "volume")
        echo $(amixer -D pulse sget Master | awk -F '[^0-9]+' '/Left:/{print $3}')
    ;;
    "date")
        echo $(date '+%H:%M | %a %d')
    ;;
    "cpu")
        cpu
    ;;
	"ram")
		ram
	;;
esac


exit