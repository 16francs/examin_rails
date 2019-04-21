#!/bin/bash

echo "--- bundle install ---"
docker-compose -f docker-compose.development.yml run --rm web bundle install

echo "--- ridgepole apply ---"
docker-compose -f docker-compose.development.yml run --rm web bundle exec rails ridgepole:apply
docker-compose -f docker-compose.development.yml run --rm web bundle exec rails ridgepole:apply RAILS_ENV=test
