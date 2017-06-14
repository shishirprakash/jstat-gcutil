# jstat-gcutil
This script is to collect jstat gcutils for zookeeper and cldb process. You can change it to based on your requirement.
There are four scripts
 - gatherStats.sh ( This is to collect the jstat and netstat)
 - stopStats.sh ( This is to stop the running daemon )
 - packageStats.sh ( This is to create a tar file of logs at current location)
 - cleanStats.sh ( This is to remove intermediate data collected)
 
Note: This script is more of gerenric log collection for process like jstat, netstat etc. One can customze based on his requirement.
