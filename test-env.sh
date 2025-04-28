#!/bin/bash

source .env 

# echo ${mahabharata[2]}

sites=$(jq -c '.[]' sites.json)


echo "$sites" | while read -r site; do
  WP_TITLE=$(echo "$site" | jq -r '.title')
  WP_PORT=$(echo "$site" | jq -r '.WP_PORT')
 
  echo $WP_TITLE
  echo $WP_PORT
  
done



# Get running container names
names=$(docker ps | awk '{if(NR>1) print $NF}')

for name in ${names}; do 
    #docker container stop $name >>$logfile
    #docker rm $name -f 
    echo "Running container: "$name 
done