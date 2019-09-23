require 'factory_bot'

Rspec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before :all do
    FactoryBot.reload
  end
end
