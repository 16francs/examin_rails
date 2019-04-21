#!/bin/bash

echo "--- docker-compose down ---"
docker-compose -f docker-compose.development.yml down

echo "--- docker-sync stop ---"
docker-sync stop
