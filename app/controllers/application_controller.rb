# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ToolBox::Concerns::Api::Response
  include ToolBox::Concerns::Api::NotImplemented
  include ToolBox::Concerns::Api::ExceptionHandler
end
