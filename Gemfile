# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "bcrypt", "~> 3.1.13"
gem "blueprinter"
gem "bootsnap", require: false
gem "dry-validation", "~> 1.8"
gem "interactor", "~> 3.0"
gem "kaminari"
gem "pg", "~> 1.1"
gem "pg_search"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "ransack"
gem "sidekiq"
gem "sidekiq-scheduler"

group :development, :test do
  gem "debug", "1.7.0" # https://github.com/ruby/debug/issues/852
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 6.0.0"
  gem "rubocop", "~> 1.45", require: false
  gem "rubocop-performance"
  gem "rubocop-rails"
end

group :development do
  gem "annotate"
  gem "bundler-audit"
end

group :test do
  gem "bullet"
  gem "simplecov"
  gem "simplecov-cobertura"
end
