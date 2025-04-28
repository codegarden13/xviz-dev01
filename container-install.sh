#!/bin/bash
# chmod 755 install-with-wpcli.sh

source .env 

# Log
current_time=$(date "+%Y%m%d-%H%M%S")
LOCAL_IP=$(ifconfig | awk '/inet /&&!/127.0.0.1/{print $2;exit}')
SCRIPTNAME="$(basename "${BASH_SOURCE[0]}" .sh)"
HOST=$(hostname)

logfile=logs/${current_time}_${SCRIPTNAME}_${HOST}.log

echo "Starting "${SCRIPTNAME} > $logfile
echo "Local IP:" ${LOCAL_IP} >> $logfile

echo "-- starting detached container --" >> $logfile
# -d heisst detached, der Container läuft auch weiter wenn man die Konsole schliesst 

docker-compose up -d >> $logfile

sleep 15

#docker-compose run --user 33:33 --rm wpcli_stg --path=stg config get >> $logfile
#docker-compose run --user 33:33 --rm wpcli_prd --path=prd config get >> $logfile

#####################################
########## Install Wordpress ########
#####################################

docker-compose run --user 33:33 --rm wpcli_prd --path=prd core install \
  --url=http://localhost:8081 \
  --title="prd" \
  --admin_user=admin_prd \
  --admin_email=admin@example.com \
  --skip-email >> $logfile

docker-compose run --user 33:33 --rm wpcli_stg --path=stg core install \
  --url=http://localhost:8082 \
  --title="stg" \
  --admin_user=admin_stg \
  --admin_email=admin@example.com \
  --skip-email >> $logfile



<<'COMMENT'

docker-compose run --user 33:33 --rm wpcli_prd config list --url=http://localhost:8081

sites=$(jq -c '.[]' sites.json)


echo "$sites" | while read -r site; do
  WP_TITLE=$(echo "$site" | jq -r '.title')
  WP_PORT=$(echo "$site" | jq -r '.WP_PORT')
  
  #wp --debug core install --url=<your-site-url> --title=<your-site-title> --admin_user=<admin-username> --admin_password=<admin-password> --admin_email=<admin-email> 
  # exec does not install, rm flag is unknown
  #docker-compose exec --user 33:33 wpcli core install --url=http://${IP}:${WP_PORT} --path=${FILE_PATH_prd}/wp-app--title="${WP_TITLE}" --admin_user=admin --admin_email=${WP_EMAIL} --skip-email >> $logfile
  #wp option update siteurl http://example.com/wp
  #echo "Configured Wordpress should be at at http://"${LOCAL_IP}":"${WP_PORT} >> $logfile

done

#############################
########## Plugins ##########
#############################

# Remove standard plugins
docker-compose run --user 33:33 --rm wpcli plugin uninstall --all --url=http://${IP}:${WP_PORT_stg}  #>> $logfile

 : '

echo "--  wpcli plugin install --" >> $logfile
# Install and list Plugins
for name in $(cat plugins.txt); do 
    echo "Installing Plugin " $name #>> $logfile
    docker-compose run --user 33:33 --rm wpcli plugin install $name --activate  #>> $logfile
done

docker-compose run --user 33:33 --rm wpcli plugin list >> $logfile

# update Plugins
docker-compose run --user 33:33 --rm wpcli plugin update --all  #>> $logfile

#delete Standard post 1

# 
echo "--   wpcli post delete 1 --" >> $logfile
docker-compose run --user 33:33 --rm wpcli post delete 1   >> $logfile

#############################
########## Themes ##########
#############################

# delete all but active Theme
docker-compose run --user 33:33 --rm wpcli theme delete --all  #>> $logfile

echo "--   wpcli theme install (online) --" >> $logfile
for name in $(cat 'input-data/themes/themes.txt'); do 
    echo $name
    docker-compose run --user 33:33 --rm wpcli theme install $name #>> $logfile
done

echo "--   wpcli theme install (local zips) --" >> $logfile

#docker exec -it docker-wp-test-wpcli bash -c "wp theme install /mnt/input-data/themes/try.zip" >> $logfile

for name in $(cat 'input-data/themes/themes-local.txt'); do 
    docker exec -it docker-wp-test-wpcli bash -c "wp theme install /mnt/input-data/themes/$name.zip" >> $logfile
    
done

echo "--   wpcli theme update --all --" >> $logfile
docker-compose run --user 33:33 --rm wpcli theme update --all  #>> $logfile

#############################
########## WP configuration #############
#############################

docker exec -it docker-wp-test-wpcli bash -c "wp option update default_pingback_flag """ >> $logfile
docker exec -it docker-wp-test-wpcli bash -c "wp option update default_ping_status """ >> $logfile
docker exec -it docker-wp-test-wpcli bash -c "wp option update default_comment_status """ >> $logfile

#############################
########## Menu #############
#############################

docker exec -it docker-wp-test-wpcli bash -c "wp menu create "menu-top"" >> $logfile
#docker exec -it docker-wp-test-wpcli bash -c "wp menu location assign menu-top primary" >> $logfile
docker exec -it docker-wp-test-wpcli bash -c "wp menu item add-custom menu-top Linktitel ' ' " >> $logfile

#############################
########## Posts ##########
#############################

#docker-compose exec wpcli bash -c "wp post create /mnt/input-data/post-content.txt --post_title='Blah'"
docker exec -it docker-wp-test-wpcli bash -c "wp post create /mnt/input-data/post-content.txt --post_title='Blah4' --post_status=publish" #test post



#create cats foto coding  etc accoding to menu ?

# Create post with content from given file


#docker-compose exec wpcli bash -c "wp post create /mnt/input-data/post-content.txt --post_title='Blah'"

#docker-compose exec wpcli bash "wp post create /mnt/input-data/post-content.txt --post_title='Blah'"

#docker exec -w -it ./input-data wpcli bash -c "wp post create /mnt/input-data/post-content.txt --post_title='Blah'"
#docker-compose exec -it wpcli bash -c "wp post create /mnt/input-data/post-content.txt --post_title='Blah'">> $logfile
#docker-compose exec -it wpcli bash
#docker-compose exec wpcli bash >> $logfile
#wp post create /mnt/input-data/post-content.txt --post_title="Blah">> $logfile ### thats it


# docker-compose run --user 33:33 --rm wpcli post create --post_title="Post from file" 'post-content.txt'
# >> $logfile

# docker exec -it docker-wp-test-wpcli bash -c "wp package install wp-cli/doctor-command:@stable" #test post
# Error: Composer directory '/.wp-cli/packages' for packages couldn't be created: mkdir(): Permission denied

# wp package install wp-cli/doctor-command:@stable

COMMENT