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
SIMULT_REQ=${2}
START=$(date +%s);
LOG=/tmp/loadTest.log
WAIT_TIME=1
ITERATIONS=0
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
        TOTAL=$((SIMULT_REQ*ITERATIONS))
        echo "Total iterations=${ITERATIONS}"
        echo "Total URL hits=${TOTAL} (approximate)"
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

#Integer check
if ! [[ "${SIMULT_REQ}" =~ ^[0-9]+$ ]]
    then
        echo "!!!!!!${SIMULT_REQ} is not an integer...try again.!!!!!!"
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
echo "Begin run : URL=${URL}, Wait time=${WAIT_TIME}, Concurrent requests=${SIMULT_REQ}" | tee -a ${LOG}
echo "#########################################################################"

while true
do
  ITERATIONS=$((ITERATIONS + 1))
  echo "Iteration=${ITERATIONS}"
  sleep ${WAIT_TIME}

  for i in `seq 1 ${SIMULT_REQ}`
  do
    echo -n `date '+%Y-%m-%d-%M%S'` " ${i} : ${SIMULT_REQ} " >> ${LOG} 
    hit_url ${URL} &
    echo "" >> ${LOG}
  done
done
