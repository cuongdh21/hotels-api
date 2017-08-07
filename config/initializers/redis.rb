unless Rails.env.test?
  yml =  Rails.root.join('config', 'redis.yml')
  if File.exist?(yml)
    config_file = YAML.load_file(yml).symbolize_keys
    ::RedisHelper.configure do |config|
      config.init_redis config_file
    end
  end
end
