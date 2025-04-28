#!/bin/bash
# chmod 755 container-checker.sh
source .env 

# Log
current_time=$(date "+%Y%m%d-%H%M%S")
LOCAL_IP=$(ifconfig | awk '/inet /&&!/127.0.0.1/{print $2;exit}')
SCRIPTNAME="$(basename "${BASH_SOURCE[0]}" .sh)"
HOST=$(hostname)

logfile=logs/${current_time}_${SCRIPTNAME}_${HOST}.log
echo "Starting "${SCRIPTNAME} > $logfile
echo "Local IP:" ${LOCAL_IP} >> $logfile
echo "## Docker Project(s) ##"
docker compose ls -q >> $logfile

echo "=== Used Docker Images per container: ===" >> $logfile

docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" >> $logfile



#docker inspect [CONTAINER_ID]


containers=$(docker ps | awk '{if(NR>1) print $NF}')


# loop through all containers
for container in $containers
do
  container_id=$(docker ps --format '{{.ID}}\t{{.Names}}' | awk -v name="$container" '$2 == name {print $1}') 
  
  
  echo "Container: $container_id $container" >> $logfile
  
  #percentages=$(docker exec $container /bin/sh -c "df -h | grep -vE '^Filesystem|shm|boot' | awk '{ print +\$5 }'")
  #mounts=$(docker exec $container /bin/sh -c "df -h | grep -vE '^Filesystem|shm|boot' | awk '{ print \$6 }'")

  # Get container root directory path
  container_root=$(docker inspect --format '{{.GraphDriver.Data.MergedDir}}' $container_id)

   echo "Container Root: $container_root" >> $logfile

  for index in ${!mounts[*]}; do
    echo "Mount ${mounts[index]}: ${percentages[index]}%" >> $logfile

    
  done
  
done