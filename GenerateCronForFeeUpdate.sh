#!/bin/bash

# make the script executable before running with chmod +x
# please edit this section
SCHEDULETIME="2021-07-29 19:15 UTC+2"
CHANPOINT="fill in you channelpoint in the following format txid:index"

# no need to edit from here
COMMAND="updatechanpolicy --base_fee_msat 0 --fee_rate 0 --time_lock_delta 40 --chan_point "
LNCLI="lncli "


# check if on umbrel, if it is on umbrel prefix docker to lncli
if uname -a | grep umbrel > /dev/null; then
    LNCLI="docker exec -i lnd lncli "
fi

schedule(){
   RUNDATE=$(date -d "$SCHEDULETIME")
   echo "$(dateToCronTime) $(generateScript)"
}

dateToCronTime(){
  #         MIN HOUR DAY MONTH
  echo "$(date -d "$RUNDATE" "+%M %H %d %m") *"
}

generateScript(){
	echo $LNCLI $COMMAND $CHANPOINT
}

build(){
	echo "$(generateScript)"
}

help () {
    cat << EOF
usage: ./build.sh [--help] [build] [send]
       <command> [<args>]
Open the script and configure values first. Then run
the script with one of the following flags:
   build             Build the command to update fees
   schedule          Schedule the update script using cron
EOF
}

all_args=("$@")
rest_args_array=("${all_args[@]:1}")
rest_args="${rest_args_array[@]}"

case $1 in
    "build" )
        build $rest_args
        ;;
    "schedule" )
  schedule $rest_args
  ;;
    "--help" )
        help
        ;;
    * )
        help
        ;;
esac
