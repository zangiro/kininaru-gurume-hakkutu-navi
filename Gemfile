source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# 非同期通信で使用

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "config"
# 開発環境と本番環境の設定で使用

# gem "redis"

gem "bootstrap-sass", "~> 3.4.1"
gem "sass-rails", ">= 3.2"
gem "jquery-rails"
# レイアウトに使用

gem "sorcery"
# ログイン関連に使用

gem "rails-i18n"
# 言語表記に使用

gem "importmap-rails"
# RailsでJavaScriptを扱う新しい方法

gem "aws-sdk-s3", require: false
# AWS S3の利用に使用

gem "gretel"
# パンくずリストの作成

gem "image_processing"
# 画像のリサイズを行う

gem "kaminari"
# ページネーションで使用

gem "bootstrap5-kaminari-views"
# ページネーションのレイアウトで使用

gem "whenever", require: false
# rakeタスクの自動処理化に必要

gem "meta-tags"
# OGPメタタグ設定に使用

gem "ransack"
# 検索機能に使用

gem "dotenv-rails"
# 開発環境"のみ"で.envファイルを用いて環境変数を扱えるようにする

gem "geocoder"
# 地名を緯度経度に変換

gem "google_places"
# google Place APIを使用するときに使う

gem "activestorage-validator"
# 画像アップロード時にバリデーションをつける

gem "draper"
# デザインパターンのdecoratorを実装できるようになる

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rubocop", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", require: false
  # Lintチェックツール

  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  # SPEC生成で使用

  gem "pry-byebug"
  # デバックモードを使うためのもの
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "letter_opener_web"
  # 開発環境でメール送信を確認するもの
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  # Selenium WebDriverなどのブラウザドライバーのバージョン管理を自動で行うためのgem
end

gem "dockerfile-rails", ">= 1.6", group: :development
