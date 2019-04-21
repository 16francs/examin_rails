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
docker-compose -f docker-compose.development.yml build --no-cache

echo "--- install docker-sync ---"
gem install docker-sync; gem install rsync

echo "--- create docker-sync volume ---"
docker volume create --name=examin_rails_sync

echo "--- docker start ---"
docker-sync start; docker-compose -f docker-compose.development.yml up -d

echo "--- create database ---"
sh docker/bin/sync/create-db.sh

echo "--- docker setup ---"
sh docker/bin/sync/setup.sh

echo "--- docker stop ---"
docker-compose -f docker-compose.development.yml down; docker-sync stop

echo "--- done ---"
