# frozen_string_literal: true

ToolBox::RemoteServices.config do |c|
  c.user_agent = 'Insert something app here'
  c.request_timeout_milliseconds = 7_000
end
