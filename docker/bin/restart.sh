#!/bin/bash

echo "--- docker-compose down ---"
docker-compose down

echo "--- docker-sync stop ---"
docker-sync stop

echo "--- docker-sync start ---"
docker-sync start

echo "--- docker-compose up ---"
docker-compose up
