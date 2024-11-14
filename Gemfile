source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

gem "importmap-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "sassc-rails"

gem "bootstrap"

gem "cpf_cnpj"

gem "image_processing", ">= 1.2"

gem 'activestorage'

gem 'turbo-rails'

gem "stimulus-rails"

gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "capybara"
  gem 'database_cleaner-active_record'
  gem 'selenium-webdriver'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end


gem "devise", "~> 4.9"
