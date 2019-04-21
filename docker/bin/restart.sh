#!/bin/bash

echo "--- docker-compose down ---"
docker-compose -f docker-compose.development.yml down

echo "--- docker-sync stop ---"
docker-sync stop

echo "--- rm server.pid ---"
docker-compose -f docker-compose.development.yml run --rm web rm -f /examin_rails/tmp/pids/server.pid

echo "--- docker-sync start ---"
docker-sync -f docker-compose.development.yml start

echo "--- docker-compose up ---"
docker-compose -f docker-compose.development.yml up
