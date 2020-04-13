#!/bin/bash

if [ `pgrep -c la_check.sh` -gt "1" ]
then
  echo "ERROR! Script already running!"
  exit 1  
fi

notify-send "CHECK LA" "Starting check LA on servers from list"

script_path=`realpath $0`
script_dir=`dirname $script_path`

#There are ${SERVERS[@]} and ${HOST}
. $script_dir/variables
####################################

echo > ${script_dir}/la.log


while true
do
  current_time=`date "+%d-%m-%Y---%H:%M:%S"`
  echo "============================================= START AT $current_time =============================================" >> ${script_dir}/la.log
  for serv in ${SERVERS[@]}
  do
    echo $serv >> ${script_dir}/la.log
    LA=$(ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${SSH_USER}@${serv}.${HOST} "sudo su - root -c 'cat /proc/loadavg'")
    FULL_LA=`echo $LA | awk '{print $1" "$2" "$3}'`
    echo $FULL_LA >> ${script_dir}/la.log
    ONE_MINUTE=`echo $LA | awk '{print $1}'`
    FIVE_MINUTES=`echo $LA | awk '{print $2}'`
    FIFTEEN_MINUTES=`echo $LA | awk '{print $3}'`

    ### check 1-min LA #########################################################
    ONE_MINUTE_MAX="100"
    CHECK_ONE_MINUTE=`echo "${ONE_MINUTE}"'>'"${ONE_MINUTE_MAX}" | bc -l`

    if [ $CHECK_ONE_MINUTE = "1" ]
    then
      notify-send -t 60000 "<span color='#d60b00'>${serv} LA ALERT</span>" "<span color='#19029c'>Current 1min LA: ---${ONE_MINUTE}---</span>"
      echo "WARN! 1 min LA to high: $CHECK_ONE_MINUTE" >> ${script_dir}/la.log
    fi
    ############################################################################

    ### check 1-5 min diff ################################################################################
    DIFF_ONE_FIVE_MINUTES_MAX="20"
    DIFF_ONE_FIVE_MINUTES=`echo "${ONE_MINUTE}-${FIVE_MINUTES}" | bc`
    CHECK_DIFF_ONE_FIVE_MINUTES=`echo "${DIFF_ONE_FIVE_MINUTES}"'>'"${DIFF_ONE_FIVE_MINUTES_MAX}" | bc -l`

    if [ $CHECK_DIFF_ONE_FIVE_MINUTES = "1" ]
    then 
      notify-send -t 60000 "<span color='#d60b00'>${serv} LA ALERT</span>" "<span color='#19029c'>Diff 1-5 min LA: ---${DIFF_ONE_FIVE_MINUTES}---</span>"
      echo "WARN! 1-5 min LA diff to high: $DIFF_ONE_FIVE_MINUTES" >> ${script_dir}/la.log
    fi
    #######################################################################################################

    ### chech 1-15 min diff ####################################################
    DIFF_ONE_FIFTEEN_MINUTES_MAX="30"
    DIFF_ONE_FIFTEEN_MINUTES=`echo "${ONE_MINUTE}-${FIFTEEN_MINUTES}" | bc`
    CHECK_DIFF_ONE_FIFTEEN_MINUTES=`echo "${DIFF_ONE_FIFTEEN_MINUTES}"'>'"${DIFF_ONE_FIFTEEN_MINUTES_MAX}" | bc -l`

    if [ $CHECK_DIFF_ONE_FIFTEEN_MINUTES = "1" ]
    then
      notify-send -t 60000 "<span color='#d60b00'>${serv} LA ALERT</span>" "<span color='#19029c'>Diff 1-15 min LA: ---${DIFF_ONE_FIFTEEN_MINUTES}---</span>"
      echo "WARN! 1-15 min LA diff to high: $DIFF_ONE_FIFTEEN_MINUTES" >> ${script_dir}/la.log
    fi
    ############################################################################
  done
  echo "=====================================================================================================================" >> ${script_dir}/la.log
  
  sleep 30
done
