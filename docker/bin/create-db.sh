#!/bin/bash

docker-compose run --rm db mysql -uroot -hdb <<EOF
CREATE USER 'examin'@'%' IDENTIFIED BY 'examin';
CREATE DATABASE examin DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
CREATE DATABASE examin_test DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON examin.* TO 'examin'@'%';
GRANT ALL PRIVILEGES ON examin_test.* TO 'examin'@'%';
EOF
