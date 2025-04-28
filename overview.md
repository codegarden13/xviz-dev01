# CLI Tests

 docker-compose exec wpcli wp core install --user 33:33 --url=http://127.0.0.1:8081 -- --title="Titel" --admin_user=admin --admin_email=mail@mail.de --skip-email

 wirft keinen fehler aber macht es nicht



- how to make a template sceleton with wp-cli - geht nicht
- import sql dump
- import data from sqlite Database to wordpress 
- https://underscores.me
- https://github.com/endel/awesome-wordpress?tab=readme-ov-file
- https://generatewp.com - tools für die WP entwicklung

in a docker-compose project directory on my local macos machine i have a subfolder which should be readable by a docker service. what is the best method to bind this subfolder in docker-compose.yaml ?

in a bash file on macos, how do i get the bashsource without the .sh extension as a variable

create docker-compose.yaml which installs mariadb, Phpmyadmin, wp-cli and two wordpress instances, one for prod and one for staging.
I want persistant data volumes for everything that i need to use for my developement. wordpress prd should use a database wordpress_prd, wordpress staging should use the database wordpress_stg.

please also give me the docker commands to install both instances using wp core install


version: '3.8'

services:
  mariadb:
    image: mariadb:latest
    container_name: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppassword
    volumes:
      - db_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    restart: always
    depends_on:
      - mariadb
    environment:
      PMA_HOST: mariadb
      MYSQL_ROOT_PASSWORD: rootpassword
    ports:
      - "8080:80"

  wordpress_prod:
    image: wordpress:latest
    container_name: wp_prod
    restart: always
    depends_on:
      - mariadb
    environment:
      WORDPRESS_DB_HOST: mariadb:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppassword
      WORDPRESS_TABLE_PREFIX: prd_
    volumes:
      - wp_prod_data:/var/www/html
    ports:
      - "8000:80"

  wordpress_staging:
    image: wordpress:latest
    container_name: wp_staging
    restart: always
    depends_on:
      - mariadb
    environment:
      WORDPRESS_DB_HOST: mariadb:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppassword
      WORDPRESS_TABLE_PREFIX: stg_
    volumes:
      - wp_staging_data:/var/www/html
    ports:
      - "8001:80"

  wpcli:
    image: wordpress:cli
    container_name: wpcli
    depends_on:
      - wordpress_prod
      - wordpress_staging
    volumes:
      - wp_prod_data:/var/www/html/prod
      - wp_staging_data:/var/www/html/staging
    entrypoint: wp

volumes:
  db_data:
  wp_prod_data:
  wp_staging_data:

