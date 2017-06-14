#!/bin/bash

logDir=/opt/mapr/logs
gatherCldbStacks=1
gatherZkStacks=1
gatherNetstatS=1
gatherNetstatPan=1

cldbPid=`cat /opt/mapr/pid/cldb.pid`
zkPid=`cat /opt/mapr/zkdata/zookeeper_server.pid`

lightPollingInterval=5
heavyPollingInterval=21

if [ `ps -ef | grep -w "gatherStats.sh daemon" | grep -v -w -e grep | tr -s '  ' ' ' | cut -f 2-3 -d " " | grep -v -w -e $$ | wc -l` -ne 0 ]; then
	echo ERROR: This script is already running!
	ps -ef | grep -w "gatherStats.sh daemon" | grep -v -w -e grep
  	exit 1
fi

if [ "n$1" = "ndaemon" ]; then
  nextHeavyPolling=0
  nextLightPolling=0
while true; do
  now=`date +%s`
  if [ $now -ge $nextHeavyPolling ]; then
      nextHeavyPolling=$(( $now + $heavyPollingInterval ))
      if [ $gatherCldbStacks -eq 1 ] && [ "n$cldbPid" != "n" ] && [ -d /proc/$cldbPid ]; then
      	jstat -gcutil -t $cldbPid 1000 20 >> $logDir/cldb.jstat.$HOSTNAME.out 2> /dev/null &
      fi
      
      if [ $gatherZkStacks -eq 1 ] && [ "n$zkPid" != "n" ] && [ -d /proc/$zkPid ]; then
      	jstat -gcutil -t $zkPid 1000 20 >> $logDir/zk.jstat.$HOSTNAME.out 2> /dev/null &
      fi
  if [ $now -ge $nextLightPolling ]; then
    nextLightPolling=$(( $now + $lightPollingInterval ))
    if [ $gatherNetstatS -eq 1 ]; then
      netstat -s | awk '{now=strftime("%Y-%m-%d %H:%M:%S "); print now $0}' >> $logDir/netstat.S.$HOSTNAME.out 2>&1 &
    fi
    if [ $gatherNetstatPan -eq 1 ]; then
      netstat -pan | awk '{now=strftime("%Y-%m-%d %H:%M:%S "); print now $0}' >> $logDir/netstat.pan.$HOSTNAME.out 2>&1 &
    fi
  fi
 fi
sleep 1
done
else 
  echo Launching collection daemon
  nohup $0 daemon < /dev/null > $logDir/gatherStats.$HOSTNAME.out 2>&1 &
fi
