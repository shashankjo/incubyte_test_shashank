# frozen_string_literal: true

module Services
  class StringCalculator

    def initialize(input_string)
      @input_string = input_string
    end

    def add
      return 0 if @input_string.empty?
    end
  end
end
