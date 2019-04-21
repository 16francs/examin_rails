#!/bin/bash

docker-compose -f docker-compose.development.yml run --rm web bundle exec rubocop
