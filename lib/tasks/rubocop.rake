task rubocop: :environment do
  options = %w[
    --display-cop-names
    --display-style-guide
  ]

  target_directories = %w[
    app
    lib
    spec
    Gemfile
  ]

  sh("bundle exec rubocop #{options.join(' ')} #{target_directories.join(' ')}")
end
