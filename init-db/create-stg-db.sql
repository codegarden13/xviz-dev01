-- create databases

CREATE DATABASE IF NOT EXISTS wordpress_stg;
CREATE DATABASE IF NOT EXISTS wordpress_prd;


-- create users and grant rights


-- GRANT ALL PRIVILEGES ON wordpress_stg.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress_stg';
-- GRANT ALL PRIVILEGES ON wordpress_prd.* TO 'wordpress'@'%' IDENTIFIED BY 'wordpress_prd';

GRANT ALL PRIVILEGES ON wordpress_stg.* TO 'wordpress'@'%' ;
GRANT ALL PRIVILEGES ON wordpress_prd.* TO 'wordpress'@'%' ;
FLUSH PRIVILEGES;

