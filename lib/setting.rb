# frozen_string_literal: true

class Setting
  DEFAULT_MATCH_CUSTOMER_WORKER_LIMIT = 150
  DEFAULT_MATCH_CUSTOMER_WORKER_PERIOD_SECONDS = 60

  DEFAULT_PUBLISH_TOPIC_DATA_WORKER_LIMIT = 300
  DEFAULT_PUBLISH_TOPIC_DATA_WORKER_PERIOD_SECONDS = 10

  def self.enable_daily_import?
    ToolBox::SiteSettings.enabled?(:enable_daily_import, false)
  end

  def self.enable_automatic_global_matching?
    ToolBox::SiteSettings.enabled?(:enable_automatic_global_matching, true)
  end

  def self.establish_customer_matches?
    ToolBox::SiteSettings.enabled?(:establish_customer_matches, true)
  end

  def self.feature_import_approvals?
    ToolBox::SiteSettings.enabled?(:feature_import_approvals, false)
  end

  def self.publish_topic_worker_limit
    ToolBox::SiteSettings.to_i(:publish_topic_worker_limit, DEFAULT_PUBLISH_TOPIC_DATA_WORKER_LIMIT)
  end

  def self.publish_topic_worker_period_seconds
    ToolBox::SiteSettings.to_i(:publish_topic_worker_period_seconds, DEFAULT_PUBLISH_TOPIC_DATA_WORKER_PERIOD_SECONDS)
  end

  def self.match_customer_worker_limit
    value = ToolBox::SiteSettings.to_i(:match_customer_worker_limit, DEFAULT_MATCH_CUSTOMER_WORKER_LIMIT)
    value = 1 if value.zero?
    value
  end

  def self.match_customer_worker_period_seconds
    value = ToolBox::SiteSettings.to_i(:match_customer_worker_period_seconds, DEFAULT_MATCH_CUSTOMER_WORKER_PERIOD_SECONDS)
    value = DEFAULT_MATCH_CUSTOMER_WORKER_PERIOD_SECONDS if value.zero?
    value
  end

  def self.get_integer_with_default(symbol, default_value)
    setting = ToolBox::SiteSettings.get(symbol, default_value)
    setting.present? ? setting.to_i : default_value
  end

  # Method used to format a hash for diagnostics logging of
  # settings
  def self.to_hash
    methods_to_include = (
      public_methods(false) - Object.public_methods(false) - [
        :to_hash, :get_integer_with_default, :get_float_with_default
      ]
    ).sort

    data = {}
    methods_to_include.each do |method|
      data[method.to_s.gsub('?', '').to_sym] = public_send(method)
    end
    data
  end
end
