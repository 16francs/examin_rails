#!/bin/bash

pwd_dir=`pwd`
current_dir=`basename $pwd_dir`

if [ $current_dir = examin_rails ]; then
  echo "--- create docker ---"
else
  echo "examin_rails ディレクトリで実行してください"
  exit
fi

echo "--- docker build ---"
docker-compose build --no-cache

echo "--- docker-sync setting ---"
docker volume create --name=examin_rails_sync

echo "--- docker-compose up ---"
docker-sync start
docker-compose up -d

echo "--- create DATABASE ---"
sh docker/bin/create-db.sh

echo "--- docker setup ---"
sh docker/bin/setup.sh

echo "--- docker-compose down ---"
docker-compose down
docker-sync stop
