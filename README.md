[![CircleCI](https://circleci.com/gh/16francs/examin_rails.svg?style=shield)](https://circleci.com/gh/16francs/examin_rails)
[![Coverage Status](https://coveralls.io/repos/github/16francs/examin_rails/badge.svg?branch=master)](https://coveralls.io/github/16francs/examin_rails?branch=master)
[![Join the chat at https://gitter.im/16francs/examin_rails](https://badges.gitter.im/16francs/examin_rails.svg)](https://gitter.im/16francs/examin_rails?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Examin (バックエンド)

[仕様書: API Blueprint](https://github.com/16francs/examin_blueprint)     
[フロントエンド: Nuxt.js](https://github.com/16francs/examin_vue)     
[バックエンド(今はこれ使ってる): Rails API](https://github.com/16francs/examin_rails)   
[バックエンド: Golang API](https://github.com/16francs/examin_go)   
[バックエンド: SpringBoot API](https://github.com/16francs/examin_boot)

## 開発環境

* Ruby 2.6.0
* Rails 6.0.0
* DB: MySQL5.7.24

## 環境構築

* `docker` ・ `docker-compose` のインストール

> https://store.docker.com/editions/community/docker-ce-desktop-mac

* `docker-sync (rsync)` のインストール

> https://github.com/EugenMayer/docker-sync/wiki

(Mac の場合,以下のコマンドでインストールできる)

> $ gem install docker-sync   
> $ gem install rcynd

* 以下のコマンドを実行

> $ cd examin_rails      
> $ sh docker/bin/create.sh   

(途中でエラーがおきた場合...)

* docker 内の MySQL に データベースを作成

> $ sh docker/bin/create-db.sh    

* その他の設定

> $ sh docker/bin/setup.sh

## テストの実行

> $ sh docker/bin/test.sh

## DB・Gemのアップデート

> $ sh docker/bin/update.sh

## 起動方法

* 以下のコマンドを実行

> $ sh docker/bin/start.sh

* 下記のURLにアクセスして確認

> http://localhost:3500

* 起動時，以下のログが出力された場合のコマンド

`A server is already running. Check /examin_rails/tmp/pids/server.pid.` 

> $ docker-compose run --rm web rm -rf tmp/   
> $ docker-compose run --rm web bundle exec rails server

## 再起動

> $ sh docker/bin/restart.sh
