# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
unless defined?(Rails::Console)

  # Configure sensitive parameters which will be filtered from the log file.
  ALLOWED_KEYS_MATCHER = /((^|_)ids?|action|controller|code|guid$)/.freeze
  SANITIZED_VALUE = '[FILTERED]'

  Rails.application.config.filter_parameters << lambda do |key, value|
    next if value.nil?

    value.replace(SANITIZED_VALUE) if !key.match(ALLOWED_KEYS_MATCHER) && value.respond_to?(:replace)
  end
end
