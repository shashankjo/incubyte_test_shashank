# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Services::StringCalculator do
  context 'with empty input string' do
    let(:input_string)  { '' }

    it 'should return 0' do
      expect(described_class.new(input_string).add).to eq 0
    end
  end

  context 'with delimeters and no negative numbers' do
    let(:input_string)  { '//;\n1;2//\n;5' }

    it 'should simply add the numerics' do
      expect(described_class.new(input_string).add).to eq 8
    end
  end

  context 'with delimeters and one negative number' do
    let(:input_string)  { '//;\n1;2//-9\n;5' }

    it 'should raise error' do
      expect { described_class.new(input_string).add }.to raise_error(StandardError, "negative numbers not allowed -9")
    end
  end

  context 'with delimeters and multiple negative numbers' do
    let(:input_string)  { '//-4;\n1;2//-9\n;5,.\\-6' }

    it 'should raise error' do
      expect { described_class.new(input_string).add }.to raise_error(StandardError, "negative numbers not allowed -4, -9, -6")
    end
  end
end
