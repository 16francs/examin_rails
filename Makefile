# docker-sync を利用する
sync-setup:
	sh docker/bin/sync/create.sh

sync-update:
	sh docker/bin/sync/update.sh

sync-start:
	sh docker/bin/sync/start.sh

sync-restart:
	sh docker/bin/sync/restart.sh

sync-stop:
	sh docker/bin/sync/stop.sh

sync-test:
	sh docker/bin/sync/test.sh

sync-lint:
	sh docker/bin/sync/lint.sh

# docker-sync を利用しない
setup:
	docker-compose build --no-cache
	docker-compose up -d
	sh docker/bin/create-db.sh
	docker-compose run --rm web bundle install
	sh docker/bin/setup.sh
	docker-compose run --rm web bundle exec rails ridgepole:apply
	docker-compose run --rm web bundle exec rails ridgepole:apply RAILS_ENV=test
	docker-compose run --rm web bundle exec rails db:seed
	docker-compose down

update:
	docker-compose run --rm web bundle install
	docker-compose run --rm web bundle exec rails ridgepole:apply
	docker-compose run --rm web bundle exec rails ridgepole:apply RAILS_ENV=test

start:
	docker-compose run --rm web rm -f /examin_rails/tmp/pids/server.pid
	docker-compose up -d

restart:
	docker-compose down
	docker-compose run --rm web rm -f /examin_rails/tmp/pids/server.pid
	docker-compose up -d

stop:
	docker-compose down

test:
	docker-compose run --rm web bundle exec rails rspec spec/

lint:
	docker-compose run --rm web bundle exec rubocop
