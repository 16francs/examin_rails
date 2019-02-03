# frozen_string_literal: true

# rubocop:disable all
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'coveralls'
require 'database_cleaner'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'simplecov'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   exit 1
# end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # DatabaseCleaner の設定
  # RSpec の実行前に一度、実行
  config.before(:suite) do
    # DBを綺麗にする手段を指定、トランザクションを張って rollback するように指定
    DatabaseCleaner.strategy = :transaction
    # truncate table文を実行し、レコードを消す
    DatabaseCleaner.clean_with(:truncation)
  end

  # test が始まるごとに実行
  config.before(:each) do
    # strategy が transaction なので、トランザクションを張る
    DatabaseCleaner.start
  end

  # test が終わるごとに実行
  config.after(:each) do
    # strategy が transaction なので、rollback する
    DatabaseCleaner.clean
  end

  # test_helpers の読み込み
  Dir[Rails.root.join('spec/test_helpers/**/*.rb')].each { |f| require f }
  config.include RequestHelper
  config.include TimeHelper

  # FactoryBot の設定
  config.include FactoryBot::Syntax::Methods
end

# モデル間の依存関係などのテスト用
# shoulda-matchers に関する設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    # shoulda-matchers を使いたいライブラリの指定
    with.library :active_record
    with.library :active_model
    with.library :rails
  end
end

# CircleCi 上でテスト結果を保存するための設定 と カバレッジ結果を測定するための設定
# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
  formatter = [Coveralls::SimpleCov::Formatter]
else
  formatter = [SimpleCov::Formatter::HTMLFormatter]
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatter)
SimpleCov.start 'rails' do
  # 除外するディレクトリの指定
  add_filter %w[
    app/channels/
    app/jobs/
    app/mailers/
    bin/
    config/
    db/
    lib/
    log/
    public/
    spec/
    storage/
    tmp/
    vendor/
  ]
end
# rubocop:enable all
