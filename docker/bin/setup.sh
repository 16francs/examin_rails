#!/bin/bash

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
