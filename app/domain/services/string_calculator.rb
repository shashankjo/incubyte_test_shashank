# frozen_string_literal: true

module Services
  class StringCalculator

    def initialize(input_string)
      @input_string = input_string
      @sanitized_array = sanitize
    end

    def add
      return 0 if @input_string.empty?

      @sanitized_array.map(&:to_i).sum
    end

    def sanitize
      @input_string.delete('^0-9-').split('')
    end
  end
end
