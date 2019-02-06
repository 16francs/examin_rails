#!/bin/bash

echo "--- docker-compose down ---"
docker-compose down

echo "--- docker-sync stop ---"
docker-sync stop

echo "--- rm server.pid ---"
docker-compose run --rm web rm -f /examin_rails/tmp/pids/server.pid

echo "--- docker-sync start ---"
docker-sync start

echo "--- docker-compose up ---"
docker-compose up
