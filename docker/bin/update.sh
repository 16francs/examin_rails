#!/bin/bash

echo "--- bundle install ---"
docker-compose run --rm web bundle install

echo "--- ridgepole apply ---"
docker-compose run --rm web bundle exec rails ridgepole:apply
docker-compose run --rm web bundle exec rails ridgepole:apply RAILS_ENV=test
