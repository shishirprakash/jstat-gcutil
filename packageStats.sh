#!/bin/bash

outDir=$1
if [ "n$outDir" = "n" ]; then
  outDir=`pwd`
fi
if [ ! -d $outDir ]; then
  echo ERROR: Could not access output directory $outDir
  exit 1
fi

logDir=/opt/mapr/logs
fileName=$outDir/jstat.$HOSTNAME.`date +"%Y-%m-%d_%H_%M_%S"`.tgz

tarMsgs="`tar --ignore-failed-read -czf $fileName $logDir/netstat.S.$HOSTNAME.out $logDir/netstat.pan.$HOSTNAME.out $logDir/zk.jstat.$HOSTNAME.out $logDir/cldb.jstat.$HOSTNAME.out /opt/mapr/logs/cldb.log* /opt/mapr/zookeeper/zookeeper-*/logs/zookeeper.log* 2>&1`" 

ret=$?
if [ $ret -eq 0 ]; then
  echo Diagnostic file created at $fileName 
else
  if [ $ret != 1 ] || [ `echo "$tarMsgs" | grep -v -e "Cannot stat: No such file or directory" -e "file changed as we read it" -e "Removing leading" | wc -l` -ne 0 ]; then
    echo ERROR: Failed to create diagnostic file $fileName with exit code $ret
    echo tar --ignore-failed-read -czf $fileName $logDir/netstat.S.$HOSTNAME.out $logDir/netstat.pan.$HOSTNAME.out $logDir/zk.jstat.$HOSTNAME.out $logDir/cldb.jstat.$HOSTNAME.out /opt/mapr/logs/cldb.log* /opt/mapr/zookeeper/zookeeper-*/logs/zookeeper.log* 
    echo "$tarMsgs"
  else
    echo jstat file created at $fileName
  fi
fi
