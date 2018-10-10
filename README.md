# Examin ~Webテストシステム~

Rails API

## 開発環境

* Ruby 2.5.1
* DB: MySQL5.7.23

## 環境構築

* .envファイルを作成

> $ touch ./.env

* 作成した.envファイルに以下の内容を記述(' '内はローカル設定を記述)

```text:.env
# データベースの設定
DATABASE_USERNAME = 'DBのユーザー名'
DATABASE_PASSWORD = 'DBのパスワード'
```

* システムに必要なGemをインストール(pathは適宜変更)

> $ ./bin/bundle install --path vendor/bundle

* データベースの構築(MySQLを使用)

> $ rails db:create

* データベースにテーブルを作成

> $ rails db:apply

## 起動方法

* MySQLの起動

> $ sudo mysql.server start

* テストを実行し，全てのテストをパスするかの確認

> $ bundle exec rspec

* サーバーを起動

> $ rails server

* 下記のURLにアクセスして確認

> http://localhost:3000
