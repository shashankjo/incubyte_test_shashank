# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audit_entries, as: :owner, class_name: 'ToolBox::AuditEntry', dependent: :destroy

    def audit!(name, description, details = nil)
      audit_entries.create!(name: "#{model_name.singular}.#{name.underscore}", description: description, details: details)
    end
  end
end
