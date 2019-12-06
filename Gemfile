# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'activerecord-import' # DB への一括登録
gem 'bcrypt', '~> 3.1.7' # ハッシュ化したパスワードを生成する用
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dotenv-rails' # .env による環境変数の設定
gem 'jbuilder', '~> 2.5' # JSON の生成用
gem 'jwt' # ログイン認証
gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 4.2'
gem 'rack-cors' # クロスドメイン対策
gem 'rack-health' # ヘルスチェック用のインターフェース
gem 'rails', '~> 6.0.0'
gem 'reform-rails' # バリデーションチェック用
gem 'ridgepole' # スキーマ管理用
gem 'roo' # Excel アップロードファイル読み込み用
gem 'rubyXL' # Excel ダウンロードファイル配布用
gem 'trailblazer-loader' # service クラスの作成用
gem 'trailblazer-rails' # service クラスの作成用

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
