#!/bin/bash

argc=$#
if [ $# -lt 1 ]
then
   echo "Usage: $0 <ip-list-file>"
   exit 1
fi

hosts=$1

function customping 
{
  ping -c 1 -W 1 $1 >/dev/null 2>&1 && echo "$1 is up" || echo "$1 is down"
#  sleep 0.01s
}

T="$(date +%s%N)"

defaultno=$(cat $hosts | wc -l) #max no of procs is as many as no. of hosts
noofproc=$defaultno

if [ -n "$2" ] #user-set no. of process instead of default
then
noofproc=$2
echo "Max processes: $noofproc"
fi

export -f customping && cat $hosts | xargs -n 1 -P $noofproc -I{} bash -c 'customping "$@"' _ {} \;

T="$(($(date +%s%N)-T))"
MS="$((T/1000000))"
echo "Elapsed time: ${MS} ms"
