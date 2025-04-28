#!/bin/bash



# make alias soes not really work
alias wp="docker-compose run --user 33:33 --rm"

docker-compose logs wpcli    
docker-compose exec wpcli wp post list # geht 


docker-compose exec wpcli wp theme install "./mnt/input-data/themes/try.zip"
docker-compose exec -it wpcli bash

#docker exec -it docker-wp-test-wp bash

#: '
for name in $(cat 'input-data/themes/themes-local.txt'); do 
    echo $name
    #docker-compose run --user 33:33 --rm wpcli theme install /mnt/input-data/themes/try.zip
    #docker-compose run --user 33:33 --rm wpcli --update

    docker-compose exec wpcli wp theme install "/mnt/input-data/themes/try.zip" ### thats it



    ##/Users/salomon/Documents/Docker-WP-Test/themes/try.zip

done

#'


