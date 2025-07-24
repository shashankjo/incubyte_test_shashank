# frozen_string_literal: true

module Services
  class StringCalculator

    def initialize(input_string)
      @input_string = input_string
      @sanitized_array = sanitize
    end

    def add
      return 0 if @input_string.empty?

      raise(StandardError, "negative numbers not allowed #{build_negative_numbers}") if contains_negative?

      @sanitized_array.map(&:to_i).sum
    end

    def contains_negative?
      @sanitized_array.any? { |arg| arg == '-' }
    end

    def sanitize
      @input_string.delete('^0-9-').split('')
    end

    def build_negative_numbers
      temp_array = @sanitized_array.dup
      negative_numbers = []

      while true
        index = temp_array.index('-')
        break if index.nil?

        negative_number = temp_array[index] + temp_array[index + 1]
        negative_numbers << negative_number
        temp_array.delete_at(index)
      end

      negative_numbers.join(', ')
    end
  end
end
