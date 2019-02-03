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

echo "--- create DATABASE ---"
sh docker/bin/create-db.sh

echo "--- docker setup ---"
sh docker/bin/setup.sh
