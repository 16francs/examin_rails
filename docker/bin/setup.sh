#!/bin/bash

pwd_dir=`pwd`
current_dir=`basename $pwd_dir`

if [ $current_dir = examin_rails ]; then
  echo "--- setup start ---"
else
  echo "examin_rails ディレクトリで実行してください"
  exit
fi

echo "--- bundle install ---"
docker-compose run --rm web bundle install --path vendor/bundle

echo "--- generate secret_key ---"
secret_key=`docker-compose run --rm web bundle exec rails secret`

echo "--- create .env file ---"
docker-compose run --rm web bash << EOF
touch .env
cat << EOS > .env
SECRET_KEY_BASE="$secret_key"

DATABASE_USERNAME="examin"
DATABASE_PASSWORD="examin"
DATABASE_HOST="db"
DATABASE_PORT="3306"
EOS
EOF

touch .env
cat << EOS > .env
SECRET_KEY_BASE="$secret_key"

DATABASE_USERNAME="examin"
DATABASE_PASSWORD="examin"
EOS

echo "--- ridgepole apply ---"
docker-compose run --rm web bundle exec rails ridgepole:apply
docker-compose run --rm web bundle exec rails ridgepole:apply RAILS_ENV=test
