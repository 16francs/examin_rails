# frozen_string_literal: true

# rubocop:disable all
# [Example]
# -> データベースに反映: bundle exec rails ridgepole:export
# -> データベースから取得: bundle exec rails ridgepole:apply
namespace :ridgepole do
  config = 'config/database.yml'
  schema = 'db/schemas/Schemafile'
  env = ENV['RAILS_ENV'] || 'development'

  if env == 'production'
    desc 'apply Schemafile'
    task :apply do
      sh "bundle exec ridgepole -c #{config} -E #{env} --apply -f #{schema}"
    end
  else # env -> development
    desc 'apply Schemafile and update schema.rb'
    task :apply do
      sh "bundle exec dotenv -f '.env' ridgepole -c #{config} -E #{env} --apply -f #{schema}"
    end

    desc 'write Schemafile from db'
    task :export do
      sh "bundle exec dotenv -f '.env' ridgepole -c #{config} -E #{env} --export --split --output #{schema}"
    end
  end
end
# rubocop:enable all
