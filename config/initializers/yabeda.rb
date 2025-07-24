# frozen_string_literal: true

require 'tool_box/monitoring/yabeda_plugins'

DEFAULT_HISTOGRAM_BUCKETS = [
  0.5, 1, 2.5, 5, 10, 25, 50, 100, 250, 500,
  1_000, 2_500, 5_000, 10_000, 20_000, 30_000, 60_000, 120_000
].freeze

# LOW_LATENCY_HISTOGRAM_BUCKETS = [
#   10, 25, 50, 100, 250, 500, 1_000, 2_500
# ].freeze

ToolBox::Monitoring::YabedaPlugins::InstrumentedAction.config do |c|
  c.default_histogram_buckets = DEFAULT_HISTOGRAM_BUCKETS

  #
  # Left as an example of custom action
  #
  # c.custom_action('gcrs_lease_history', 'Services::Customers::LeaseHistory::Actions::Obtain') do |a|
  #   a.description = 'Obtain Lease History action'
  #   a.labels = [:source]
  #   a.histogram_buckets = LOW_LATENCY_HISTOGRAM_BUCKETS
  # end
end

ToolBox::Monitoring::YabedaPlugins::ToolBoxRemoteServices.bind_metrics(DEFAULT_HISTOGRAM_BUCKETS)

Yabeda.configure!
