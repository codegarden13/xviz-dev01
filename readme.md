# wordpress dev enviroment
There may be better ways to do that ...

## Overview
Docker approach: Reproducable enviroment for wordpress development. 
- It installs php webserver, database server, phpmyadmin, two wordpress instances dev and prd and two dedicatet instances of wp-cli to control dev and prd.
- prd and stg instances of Wordpress can be configureds and controled by wp-cli.
  - http://localhost:8080 -> phpmyadmin
  - http://localhost:8081 -> wordpress prd
  - http://localhost:8082 -> wordpress stg

## Install

- ``` docker compose up -d ``` to just run the containers. No further configurations on the wordpress instances
- ``` container-install.s ``` to get the above plus a bunch of costumizations: Enhanced file upload size, install themes and plugins based on input files