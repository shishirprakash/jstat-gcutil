#!/bin/bash

logDir=/opt/mapr/logs
rm -rf $logDir/netstat.S.$HOSTNAME.out $logDir/netstat.pan.$HOSTNAME.out $logDir/cldb.jstat.$HOSTNAME.out $logDir/zk.jstat.$HOSTNAME.out
echo Cleaned up stats file from $logDir
