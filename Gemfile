# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.2.3'
# ruby '2.6.3'

# Use Puma as the app server
gem 'puma', '~> 3.11'

#-------------- misc. ----------------------#
gem 'json'
gem 'meta-tags'
gem 'sitemap_generator'
gem 'mojimoji'
gem 'rake-remote_task'
gem 'browser', '~> 2.2.0'

#------------- template engine -------------#
gem 'erb2haml'
gem 'erb2slim' # erb2slim-0.0.1/lib/erb2slim.rb の２行目を require 'html2haml/html' に修正する必要あり
gem 'haml'
gem 'haml-rails'
gem 'haml2slim'
gem 'html2haml'
gem 'html2slim'
gem 'slim'
gem 'slim-rails'
gem 'will_paginate'
gem 'bootstrap-will_paginate', '~> 1.0'

#------------- front-end -------------#
gem 'autosize'
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
# gem 'jquery-turbolinks' # jQueryの挙動に影響を及ぼすため
gem 'sass-rails', '~> 5.0'
gem "sassc-rails" # precompile の高速化
# gem 'turbolinks', '~> 5' # jQueryの挙動に影響を及ぼすため
gem 'uglifier', '>= 1.3.0'
gem 'autoprefixer-rails'
gem 'sass'
gem 'gretel'
gem 'font-awesome-rails'
gem 'jquery-timepicker-rails'

gem 'data-confirm-modal'
gem 'rails-assets-tether', '~> 1.4.3', :source => 'https://rails-assets.org/'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', github: 'rails/webpacker'
# gem 'rails-assets-tether'
# therubyracer は、JavaScript のエンジンである v8 を Ruby から使えるようにする gem
# 大量にメモリを消費するので node.js に切り替え
# gem 'therubyracer'
gem "wysiwyg-rails"

# JS用のi18n
gem 'i18n-js'
# JS用のフラッシュメッセージ
gem 'toastr-rails'

# google map
gem "gmaps4rails"
gem "geocoder"

# 複数の入力フォーム作成
gem 'cocoon'

# class="active"を動的につけられる
gem 'active_link_to'

# 都道府県利用メソッド
gem 'jp_prefecture'

#------------- database -------------#
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'

#- multiple database connection for data migrate --#
gem 'ruby-mysql'
gem 'sequel'
# schemaの情報をファイルの先頭もしくは末尾にコメントをつける
gem 'annotate'
# MySQL server has gone away 対策
gem 'mysql_retry_lost_connection'
# カラムの要素定義に使用
gem 'enumerize'

# elasticsearch
gem 'elasticsearch'
gem 'elasticsearch-api'
gem 'elasticsearch-transport'
gem 'elasticsearch-dsl'
gem 'elasticsearch-model', github: 'elastic/elasticsearch-rails', branch: '5.x'
gem 'elasticsearch-rails', github: 'elastic/elasticsearch-rails', branch: '5.x'
gem 'redis'
# elasticsearchのキーワード検索で使用する
gem 'miyabi'

# 静的データを持てるようにするgem
gem 'active_hash'
# 一括処理
gem 'activerecord-import'

# ~~~~~~~~~~~~~~~~~ authentication ~~~~~~~~~~~~~~~~~#
gem 'devise'
gem 'devise-i18n'
gem 'omniauth', '~> 1.7.0'
gem 'omniauth-facebook', '>= 4.0.0'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'

# session store
gem 'activerecord-session_store'

# soft delete
gem 'paranoia'

# ~~~~~~~~~~~~~~~~~ 権限管理 ~~~~~~~~~~~~~~~~~#

gem 'the_role'
if ENV['RAILS_ENV'] == 'development'
  gem 'the_role_api'
  gem 'the_role_management_panel'
  gem 'the_string_to_slug'
end

# Other
group :development do
  gem 'faker'
  gem 'pry-rails'
end

#------------- PDF -------------#
gem 'wicked_pdf' # yum install -y ipa-gothic-fonts で日本語フォントを合わせてインストール
#gem 'wkhtmltopdf-binary-edge'
gem 'wkhtmltopdf-binary'

#------------- debug -------------#
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'meta_request'
  gem 'pry-alias'
  gem 'pry-byebug'
  gem 'stackprof'
end

#------------- console -------------#
group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

#------------- programing tools -------------#
group :development, :test do
  # Static analysis tools
  gem 'rubocop', require: false
  gem 'rubycritic', require: false
  # profiler
  gem 'ruby-prof'
end

#------------- testing tools -------------#
group :development, :test do
  gem 'bullet'
  gem 'minitest'
  gem 'minitest-rails'
  gem 'test-unit' if RUBY_VERSION >= '2.2'

  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'parallel_tests'
  gem 'spring-commands-rspec'
  gem 'launchy'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'rails-controller-testing'

  gem 'vcr'
  gem 'simplecov'
  gem 'timecop'

  gem 'rspec-core'
  gem 'rspec-expectations'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'rspec-support'

  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'capybara-email'
  gem 'email_spec'
  gem 'webdrivers'
  gem 'turnip'
  gem 'dotenv-rails'
end

#------------- その他 -------------#
gem 'bootsnap', '>= 1.1.0', require: false
gem 'mini_racer'

gem 'mime-types'
gem 'rack-attack', '~> 5.0.1'
gem 'whenever', '~> 0.10.0', :require => false

gem 'rename'

#------------- original -------------#
# material design for bootstrap pro
gem 'renopertymdb', path: '../renopertymdb'
# administration console
gem 'renopertyadmin', path: '../renopertyadmin'
