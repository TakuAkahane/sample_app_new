# encoding: utf-8
# frozen_string_literal: true

# DatabaseCleaner
RSpec.configure do |config|
  # 維持したいデータはここに列挙する
  data_to_maintains = {except: %w{companies}}
  config.use_transactional_fixtures = false

  # RSpecの実行前に一度、実行
  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        set use_transactional_fixtures value
      MSG
    end
    # 不要なデータを削除
    DatabaseCleaner.clean_with(:truncation, data_to_maintains)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # rack_test以外は別プロセスからデータ参照可能にする
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation, data_to_maintains
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
