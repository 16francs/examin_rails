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
* DB: MySQL5.7.23

## 環境構築

* .envファイルを作成

> $ touch ./.env

* 作成した.envファイルに以下の内容を記述(' '内はローカル設定を記述)

```text:.env
# データベースの設定
DATABASE_USERNAME = 'DBのユーザー名'
DATABASE_PASSWORD = 'DBのパスワード'
SECRET_KEY_BAE = '認証に使用する秘密鍵'
```

* (秘密鍵の生成をしたい場合は以下のコマンドを実行する)

> $ bundle exec rails secret

* システムに必要なGemをインストール(pathは適宜変更)

> $ ./bin/bundle install --path vendor/bundle

* データベースの構築(MySQLを使用)

> $ bundle exec rails db:create

* データベースにテーブルを作成

> $ bundle exec rails ridgepole:apply

## 起動方法

* MySQLの起動

> $ sudo mysql.server start

* テストを実行し，全てのテストをパスするかの確認

> $ bundle exec rspec

* (任意のテストを実行する場合, 下記のコマンドを実行する方が速い)

> $ bin/rspec spec/

* サーバーを起動

> $ bundle exec rails server

* 下記のURLにアクセスして確認

> http://localhost:3000

