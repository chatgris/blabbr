if ENV['HOPTOAD']
  HoptoadNotifier.configure do |config|
    config.api_key = ENV['HOPTOAD']
  end
end
