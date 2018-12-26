[![CircleCI](https://circleci.com/gh/16francs/examin_rails.svg?style=shield)](https://circleci.com/gh/16francs/examin_rails)
[![Coverage Status](https://coveralls.io/repos/github/16francs/examin_vue/badge.svg)](https://coveralls.io/github/16francs/examin_rails)
[![Join the chat at https://gitter.im/16francs/examin_rails](https://badges.gitter.im/16francs/examin_rails.svg)](https://gitter.im/16francs/examin_rails?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Examin (バックエンド)

[仕様書: API Blueprint](https://github.com/16francs/examin_blueprint)     
[フロントエンド: Vue.js](https://github.com/16francs/examin_vue)     
[バックエンド: Rails API](https://github.com/16francs/examin_rails)

## 開発環境

* Ruby 2.5.1
* DB: MySQL5.7.23

## 環境構築

### 環境構築(フロントエンドのみ)

* ルートディレクトリで以下のコマンドを実行

> $ mkdir ./client

* 作成したディレクトリに，examin_vueプロジェクトを格納

> $ git clone https://github.com/16francs/examin_vue.git

(examin_vueをgithubからクローンする)

> $ mv examin_vue ./client

(クローンしたプロジェクトをclientディレクトリに移動する)

* 必要な物ををインストールする

> $ yarn install

### 環境構築(バックエンドのみ)

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


### 環境構築(フロントエンド + バックエンド)

* バックエンドのシステムをクローンする

> $ git clone https://github.com/16francs/examin_rails.git

* 作業ディレクトリの変更

> $ cd ./examin_rails

* フロントエンドをクローンするディレクトリの作成

> $ mkdir ./client

* フロントエンドのシステムをクローンし，ファイルを移動

> $ git clone https://github.com/16francs/examin_vue.git    
> $ mv ./examin_vue ./client    
> $ rm -rf ./examin_vue

* .envファイルを作成

> $ cd ./examin_rails
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

* フロントエンドでも同様に必要な物をインストールする

> $ cd ./client
> $ yarn install

## 起動方法

### 起動方法(フロントエンドのみ)

* テストを実行し，全てのテストをパスするかの確認

> $ yarn test

* サーバーを起動

> $ yarn run dev

* 下記のURLにアクセスして確認

> http://localhost:3000

### 起動方法(バックエンドのみ)

* MySQLの起動

> $ sudo mysql.server start

* テストを実行し，全てのテストをパスするかの確認

> $ bundle exec rspec

* (任意のテストを実行する場合, 下記のコマンドを実行する方が速い)

> $ bin/rspec spec/

* サーバーを起動

> $ rails server

* 下記のURLにアクセスして確認

> http://localhost:3000


### 起動方法(フロントエンド + バックエンド)

* MySQLの起動

> $ sudo mysql.server start

* フロントエンドのテストを実行

> $ cd ./client   
> $ yarn test

* バックエンドのテストを実行

> $ cd ./examin_rails   
> $ bundle exec rspec

* テストをパスしたのを確認後，以下のコマンドを実行しサーバーを起動

> $ foreman start

* 下記のURLにアクセスして確認(フロントのポート番号はターミナルを確認)

> http://localhost:5100

(Rails 用のURL)

> http://localhost:3000
