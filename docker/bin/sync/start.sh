#!/bin/bash

echo "--- rm server.pid ---"
docker-compose -f docker-compose.development.yml run --rm web rm -f /examin_rails/tmp/pids/server.pid

echo "--- docker-sync start ---"
docker-sync start

echo "--- docker-compose up ---"
docker-compose -f docker-compose.development.yml up
