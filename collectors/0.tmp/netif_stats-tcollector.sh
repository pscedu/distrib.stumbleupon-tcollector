#!/bin/bash

SLEEP=10
SYS=/sys/class/net

keys="port_rcv_packets port_xmit_packets"
# these keys need to be multiplied by 4
#datakeys="port_rcv_data port_xmit_data"

while [ 1 ] 
do
  date=`date +%s`
#/sys/class/infiniband/mlx4_0/ports/1/counters/port_rcv_data
  for iface in `ls ${IB_SYS}`; 
    do
    for port in `ls ${IB_SYS}/${iface}/ports`
      do
      link=`cat ${IB_SYS}/${iface}/ports/${port}/phys_state`
      echo $link | grep -i linkup > /dev/null 2>/dev/null
      if [ $? == 0 ]  
	  then 	
	  for k in ${keys}
	    do
	    echo "infiniband.${k} ${date} `cat ${IB_SYS}/${iface}/ports/${port}/counters/${k}` iface=${iface} port=${port}"
	  done
	  
	  for k in ${datakeys}
	    do
	    echo "infiniband.${k} ${date} $((4 * `cat ${IB_SYS}/${iface}/ports/${port}/counters/${k}`)) iface=${iface} port=${port}"
	  done
      fi
    done
  done
  # ugly hack but I can't seem to be able to reset counters on nodes with > 1
  # HBA otherwise.
  /usr/sbin/perfquery -R 2>/dev/null >/dev/null
  /usr/sbin/perfquery -R -P 255 2>/dev/null >/dev/null
  sleep ${SLEEP}
done
