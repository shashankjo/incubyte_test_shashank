unless ENV['SUPPRESS_SIMPLECOV'] == 'true'
  require 'simplecov'
  require 'simplecov_json_formatter'

  SimpleCov.start do
    enable_coverage :branch

    if ENV['CC_TEST_REPORTER_ID']
      formatter SimpleCov::Formatter::JSONFormatter
    else
      formatter SimpleCov::Formatter::HTMLFormatter
    end

    add_filter '.bundle'
    add_filter 'config'
    add_filter 'lib'
    add_filter 'spec'
    coverage_dir File.join(%w(tmp coverage))
  end
end
