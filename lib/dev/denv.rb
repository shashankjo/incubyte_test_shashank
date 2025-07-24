# frozen_string_literal: true

unless Object.const_defined?(:DENV_INITIALIZER_LOADED)
  Object.const_set(:DENV_INITIALIZER_LOADED, true)

  require 'denv'

  DEnv.logger.level = Logger::FATAL

  unless ENV['DENV_DISABLED'] == 'true'
    if ENV['CI'] == 'true' || ENV['RAILS_ENV'] == 'test'
      DEnv.from_file('../../.env').from_file('../../.ci.env')
    else
      DEnv.from_file('../../.env').from_file('../../.local.env')
    end
  end

  denv_log_level    = ENV['DENV_LOG_LEVEL'] || DEnv.changes['DENV_LOG_LEVEL'] || 'FATAL'
  DEnv.logger.level = Logger.const_get(denv_log_level)

  DEnv.append_env!
end
