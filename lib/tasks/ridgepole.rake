namespace :db do
  config = 'config/database.yml'
  schema = 'db/schemas/Schemafile'
  env = ENV['RAILS_ENV'] || 'development'

  desc 'apply Schemafile and update schema.rb'
  task :apply do
    sh "bundle exec dotenv -f '.env' ridgepole -c #{config} -E #{env} --apply -f #{schema}"
  end

  desc 'write Schemafile from db'
  task :export do
    ENV['RAILS_ENV'] ||= 'development'
    sh "bundle exec dotenv -f '.env' ridgepole -c #{config} -E #{env} --export --split --output #{schema}"
  end
end
