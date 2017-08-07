module RedisHelper
  EXPIRATION_TIME_IN_SECONDS = 300

  def self.configure
    @configs = {}
    yield self
  end

  def self.init_redis(options)
    @redis = ::Redis.new options
  end

  def self.write_hash(key, field, value_as_hash)
    redis.hset key, field, to_camel_case(value_as_hash)
    redis.expire key, EXPIRATION_TIME_IN_SECONDS
  end

  def self.read_all_hash(key)
    redis.hgetall key
  end

  def self.redis
    @redis
  end

  def self.to_camel_case(value)
    value.deep_transform_keys { |key| key.to_s.camelize :lower }.to_json
  end

  private_class_method :to_camel_case
end
