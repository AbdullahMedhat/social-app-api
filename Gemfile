source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'

# Device Gem for authentication
# gem 'devise', '~> 4.3.0'
gem 'devise_token_auth', '~> 0.2.0'
gem 'simple_token_authentication', '~> 1.15.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # rspec gems
  gem 'database_cleaner', '~> 1.6.2'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker', '~> 1.8.4'
  gem 'rspec-rails', '~> 3.7.1'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'rspec-retry', '~> 0.5.6'
  gem 'spring-commands-rspec', '~> 1.0.4'

  # capybara gem
  gem 'capybara', '~> 2.15.4'
  gem 'capybara-email', '~> 2.5.0'

  # byebug gem for debugging
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Pry rails gem
  gem 'pry-rails'

  # Gem for pagination
  gem 'will_paginate', '~> 3.1.0'

end

group :development do
  # Spring speeds up development
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Rubocop
  gem 'rubocop', '~> 0.51.0'
end

group :test do
  gem 'simplecov', '~> 0.15.1', require: false
end
