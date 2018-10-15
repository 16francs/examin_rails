[![CircleCI](https://circleci.com/gh/nishikawatadashi/examin.svg?style=shield&circle-token=41b2aced5a2b8630217b7b2b187196dc831b0625)](https://circleci.com/gh/nishikawatadashi/examin)

# Examin (Webテストシステム)

フロントエンド: Vue.js     
バックエンド: Rails API      

## 開発環境

* Ruby 2.5.1
* DB: MySQL5.7.23

## 環境構築

### 環境構築(APIのみ)

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

### 環境構築(フロント)

* ルートディレクトリで以下のコマンドを実行

> $ mkdir ./client

* 作成したディレクトリに，examin_vueプロジェクトを格納

> $ git clone https://github.com/nishikawatadashi/examin_vue.git

(examin_vueをgithubからクローンする)

> $ mv examin_vue ./client

(クローンしたプロジェクトをclientディレクトリに移動する)

* 必要な物ををインストールする

> $ npm install

## 起動方法

### 起動方法(APIのみの場合)

* MySQLの起動

> $ sudo mysql.server start

* テストを実行し，全てのテストをパスするかの確認

> $ bundle exec rspec

* サーバーを起動

> $ rails server

* 下記のURLにアクセスして確認

> http://localhost:3000

### 起動方法(フロントを含めた実行方法)

* MySQLの起動

> $ sudo mysql.server start

* Railsのテストを実行

> $ cd ./examin     
> $ bundle exec rspec

* テストをパスしたのを確認後，以下のコマンドを実行しサーバーを起動

> $ foreman start

* 下記のURLにアクセスして確認(フロントのポート番号はターミナルを確認)

> http://localhost:3000

(Rails 用のURL)

> http://localhost:`ターミナルに表示されているポート番号`

