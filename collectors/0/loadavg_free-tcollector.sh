#!/bin/bash

SLEEP=10

# mem.buffers
# mem.cached
# mem.free
# mem.used
# proc.loadavg.1m
# proc.loadavg.5m

host=`/bin/hostname -s`

while [ 1 ] 
do
  date=`date +%s`
  OUT=`uptime`

#  echo "proc.loadavg.1m $date `echo $OUT | awk '{print $10}' | awk -F , '{print $1}'` host=${host}"
#  echo "proc.loadavg.5m $date `echo $OUT | awk '{print $11}' | awk -F , '{print $1}'` host=${host}"
  echo "proc.loadavg.1m $date `echo $OUT | awk '{print $10}' | awk -F , '{print $1}'`"
  echo "proc.loadavg.5m $date `echo $OUT | awk '{print $11}' | awk -F , '{print $1}'`"

  OUT=`free|grep Mem:`
#  echo "mem.used $date `echo $OUT | awk '{print $3}'` host=${host}"
#  echo "mem.free $date `echo $OUT | awk '{print $4}'` host=${host}"
#  echo "mem.buffers $date `echo $OUT | awk '{print $6}'` host=${host}"
#  echo "mem.cached $date `echo $OUT  | awk '{print $7}'` host=${host}"

  OUT=`free|grep Mem:`
  echo "mem.used $date `echo $OUT | awk '{print $3}'`"
  echo "mem.free $date `echo $OUT | awk '{print $4}'`"
  echo "mem.buffers $date `echo $OUT | awk '{print $6}'`"
  echo "mem.cached $date `echo $OUT  | awk '{print $7}'`"
  
  sleep ${SLEEP}
done
