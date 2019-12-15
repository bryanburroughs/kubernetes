#!/bin/bash
##
## LoadTest.sh
##
## Script to 
##
##
## Notes: 
##
## Author: Bryan Burroughs
##
##
####################################################################
# $Id: $

URL=${1}
NUM=${2}
START=$(date +%s);
LOG=/tmp/loadTest.log
WAIT_TIME=1
COUNT=0
TOTAL=0

#==================================================================#
# Functions
#==================================================================#

usage(){
        echo "Usage: $0 [ URL ]  [ CALLS_PER_SECOND ]"
        echo
        echo "Example: $0 http://tron.burroughs.blb:8080 10"
        }

function trap_cmd {
        echo "You hit control+C .... Stopping script."
        TOTAL=$((NUM*COUNT))
        echo "Total iterations=$COUNT"
        echo "Total URL hits=$TOTAL (approximate)"
        exit 0
}

#==================================================================#
# Parse Arguments
#==================================================================#

if [ $# -lt 2 ]
then
        usage
        exit 1
fi

#========================================================================
# Main
#========================================================================

trap 'trap_cmd' INT

hit_url () {
  curl -s "${1}" > /dev/null 2>&1
}

echo "#########################################################################"
echo "Begin run : URL=${URL}, Wait time=${WAIT_TIME}, Concurrent requests=${NUM}" | tee -a ${LOG}
echo "#########################################################################"

while true
do
  COUNT=$((COUNT + 1))
  echo "Iteration=$COUNT"
  sleep ${WAIT_TIME}

  for i in `seq 1 ${NUM}`
  do
    echo -n `date '+%Y-%m-%d-%M%S'` " ${i} : ${NUM} " >> ${LOG} 
    hit_url ${URL} &
    echo "" >> ${LOG}
  done
done
