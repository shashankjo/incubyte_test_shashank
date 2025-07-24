# frozen_string_literal: true

require 'bcrypt'

# Reduce the cost in non-production environments to minimum permitted
ToolBox::WebServer.production? ? BCrypt::Engine.cost = 10 : BCrypt::Engine.cost = BCrypt::Engine::MIN_COST
