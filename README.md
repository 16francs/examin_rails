[![CircleCI](https://circleci.com/gh/16francs/examin_rails.svg?style=shield)](https://circleci.com/gh/16francs/examin_rails)
[![Coverage Status](https://coveralls.io/repos/github/16francs/examin_rails/badge.svg?branch=master)](https://coveralls.io/github/16francs/examin_rails?branch=master)
[![Join the chat at https://gitter.im/16francs/examin_rails](https://badges.gitter.im/16francs/examin_rails.svg)](https://gitter.im/16francs/examin_rails?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Examin (バックエンド)

[インフラ関連: Docker](https://github.com/16francs/examin)     
[仕様書: API Blueprint](https://github.com/16francs/examin_blueprint)     
[フロントエンド: Nuxt.js](https://github.com/16francs/examin_vue)     
[バックエンド(今はこれ使ってる): Rails API](https://github.com/16francs/examin_rails)   
[バックエンド(移行予定): Golang API](https://github.com/16francs/examin_go)   
[バックエンド: SpringBoot API](https://github.com/16francs/examin_boot)

## 開発環境

* Ruby 2.6.0
* Rails 6.0.0
* DB: MySQL5.7.24

## docker-sync 使う

### 環境構築

* 初回のみ

> $ make sync-setup

* 更新を反映させる時

> $ make sync-update

### 起動方法

* 以下のコマンドを実行

> $ make sync-start

* 下記のURLにアクセスして確認

> http://localhost:3500

### 再起動

> $ make sync-restart

### 停止

> $ make sync-stop

---

##  docker-sync 使わない

### 環境構築

> $ make setup

* 更新を反映させる時

> $ make update

### 起動方法

* 以下のコマンドを実行

> $ make start

* 下記のURLにアクセスして確認

> http://localhost:3500

### 再起動

> $ make restart

### 停止

> $ make stop
