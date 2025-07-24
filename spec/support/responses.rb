module ResponsesHelpers

  extend RSpec::SharedContext

  def response_logger
    @response_logger ||= ToolBox::WebServer.debug? ? Logger.new(STDOUT) : ::Rails.logger
  end

  def response_debug(msg)
    response_logger.debug msg.to_s
  end

  def expect_response(code, content_type = nil)
    expect(response.status).to eql code
    expect(response.headers['Content-Type']).to match(%r[^#{content_type}]) if content_type.present?
  end

  def expect_successful_response(content_type = nil)
    expect_response 200, content_type
  end

  let(:json_content_type) { 'application/json' }

  def expect_successful_json_response
    expect_successful_response json_content_type
  end

  def expect_successful_pdf_response
    expect_successful_response 'application/pdf'
  end

  def expect_successful_xls_response
    expect_successful_response 'application/vnd.ms-excel'
  end

  def expect_response_include(text)
    expect(response.body).to include(text)
  end

  def build_http_response(body, options = {})
    if options[:yaml]
      YAML.load body
    else
      options = { body: body, status: 200, version: 1, headers: {} }.update options
      HTTP::Response.new options
    end
  end

  def build_oauth_response(body)
    faraday_response = double('Faraday::Response',
                              headers: {'Content-Type' => 'application/json'},
                              status: 200,
                              body: body)
    OAuth2::Response.new(faraday_response)
  end

  def stub_get(body, options = {})
    stub_request :get, body, options
  end

  def net_stub_get(body, options = {})
    stub_get body, options.update(klass: Net::HTTP)
  end

  def stub_post(body, options = {})
    stub_request :post, body, options
  end

  def net_stub_post(body, options = {})
    stub_post body, options.update(klass: Net::HTTP)
  end

  def excon_stub_post(body, options = {})
    stub_excon_call :post, body, options
  end

  def oauth_stub_post(body)
    stub_oauth_call body
  end

  def stub_excon_call(type, body, options)
    klass = Excon::Connection
    response_debug "stub_excon_call | will return body (#{body.try(:size) || 'nil'}) on next #{type} for #{klass}"
    allow_any_instance_of(klass).to receive(:request) do |instance, *args|
      response_debug "stub_excon_call | #{klass.name} : #{type} | #{instance.class.name} : received (#{args.size}) #{args.to_yaml}"
      res = build_http_response body, options
      response_debug "stub_excon_call | #{klass.name} : #{type} | responding with #{res.class.name} #{res.status.to_s} #{res.content_type}"
      res
    end
  end

  def stub_oauth_call(body)
    klass = OAuth2::Client
    response_debug "stub_oauth_call | will return body (#{body.try(:size) || 'nil'}) on next post for #{klass}"
    allow_any_instance_of(klass).to receive(:request) do |instance, *args|
      response_debug "stub_oauth_call | #{klass.name} : post | #{instance.class.name} : received (#{args.size}) #{args.to_yaml}"
      res = build_oauth_response(body)
      response_debug "stub_oauth_call | #{klass.name} : post | responding with #{res.class.name} #{res.status.to_s}"
      res
    end
  end

  def stub_request(type, body, options = {})
    klass = options.delete(:klass) || HTTP::Client
    stub_request_exception(type, klass, options) || stub_request_call(type, body, klass, options)
  end

  def stub_post_exception(exception, options = {})
    klass                 = options.delete(:klass) || HTTP::Client
    options[:status]      = :exception
    options[:error_class] = exception.class
    options[:message]     = exception.message
    stub_request_exception :post, klass, options
  end

  def stub_request_exception(type, klass, options = {})
    return nil unless options[:status] == :exception

    error_class ||= options.fetch :error_class, ::Exception
    message     ||= options.fetch :message, 'something went wrong'
    response_debug "stub_request_exception | #{klass.name} : #{type} | will raise #{error_class} [#{message}]"
    allow_any_instance_of(klass).to receive(type).and_raise(error_class, message)
  end

  def stub_request_call(type, body, klass, options)
    response_debug "stub_request_call | will return body (#{body.try(:size) || 'nil'}) on next #{type} for #{klass.name}"
    allow_any_instance_of(klass).to receive(type) do |instance, *args|
      response_debug "stub_request_call | #{klass.name} : #{type} | #{instance.class.name} : received (#{args.size}) #{args.to_yaml}"
      res = build_http_response body, options
      response_debug "stub_request_call | #{klass.name} : #{type} | responding with #{res.class.name} #{res.status.to_s} #{res.content_type}"
      res
    end
  end

end

RSpec.configure do |config|

  config.include ResponsesHelpers

end
