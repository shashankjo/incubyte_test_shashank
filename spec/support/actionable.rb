require 'actionable/rspec/matchers'
require 'actionable/rspec/stubs'

ENV['ACTIONABLE_BACKTRACE_QTY'] = '10'

module Actionable
  module RspecMatchers
    # Simple builder for setting actionable expectations
    class ActionableBuilder
      include RSpec::Matchers
      include RSpec::Mocks::ExampleMethods
      def initialize(klass, expectation)
        @klass = klass
        @expectation = expectation
        @args = nil
        @kwargs = nil
        @ordered = false
      end
      def with(*args, **kwargs)
        @args = args
        @kwargs = kwargs
        self
      end

      def ordered
        @ordered = true
        self
      end

      def and_succeed(fixtures = {})
        result = @klass.mock_success fixtures
        stub_result result
      end

      def and_fail(code, message = '', fixtures = {})
        result = @klass.mock_failure code, message, fixtures
        stub_result result
      end

      private

      def stub_result(result)
        @ordered ? stub_ordered_result(result) : stub_unordered_result(result)
      end

      def stub_unordered_result(result)
        if @expectation == :expect
          if @args.blank? && @kwargs.blank?
            expect(@klass).to receive(:run).and_return(result)
          else
            expect(@klass).to receive(:run).with(*@args, **@kwargs).and_return(result)
          end
        else
          if @@args.blank? && @kwargs.blank?
            allow(@klass).to receive(:run).and_return(result)
          else
            allow(@klass).to receive(:run).with(*@args, **@kwargs).and_return(result)
          end
        end
        self
      end

      def stub_ordered_result(result)
        if @expectation == :expect
          if @args.blank? && @kwargs.blank?
            expect(@klass).to receive(:run).ordered.and_return(result)
          else
            expect(@klass).to receive(:run).ordered.with(*@args, **@kwargs).and_return(result)
          end
        else
          if @args.blank? && @kwargs.blank?
            allow(@klass).to receive(:run).ordered.and_return(result)
          else
            allow(@klass).to receive(:run).ordered.with(*@args, **@kwargs).and_return(result)
          end
        end
        self
      end
    end

    def expect_actionable(klass)
      ActionableBuilder.new(klass, :expect)
    end
    def allow_actionable(klass)
      ActionableBuilder.new(klass, :allow)
    end
  end
end

RSpec.configure do |config|
  config.include Actionable::RspecMatchers
end
