# frozen_string_literal: true

ToolBox::SiteSettings.config do |c|
  c.enable_cache = !Rails.env.test?
  c.cache_expires_in = 15.seconds
end
