# frozen_string_literal: true

require "faker"

module Faker
  class Year < Base
    class << self
      def ago(max = 100, min = 10)
        ::Time.zone.now.year - min - rand(max - min + 1)
      end
    end
  end

  class Bank < Base
    class << self
      ROUTING_NUMBERS = [
        '021033519', '021081859', '026005720', '053111690', '053207106', '053906041', '062105493',
        '063113057', '063114289', '066012333', '067001275', '071000039', '071026385', '072412778',
        '082904373', '091905059', '101114691', '102201040', '103109374', '103112659', '104107786',
        '111908583', '121144285', '121144463', '211386801', '221371770', '262275958', '275080525',
        '314977188', '325170835'
      ].freeze

      def routing_number
        ROUTING_NUMBERS.sample
      end

      def account_number
        Number.random_digits(6, 12)
      end
    end
  end

  class Company < Base
    class << self
      def tax_id
        numerify('#' * 9)
      end
    end
  end

  class Name < Base
    class << self
      def safe_first_name
        first_name.gsub(/[^\w\s]/, '')
      end

      def safe_last_name
        last_name.gsub(/[^\w\s]/, '')
      end

      def safe_full_name
        "#{safe_first_name} #{safe_last_name}"
      end
    end
  end

  class Number < Base
    class << self
      def random_between(min = 10, max = 100)
        min + rand(max - min + 1)
      end

      def digits(size)
        rand(1..10).to_s + numerify('#' * (size - 1))
      end

      def random_digits(min = 3, max = 10)
        digits(min + rand(max - min + 1))
      end
    end
  end

  class PhoneNumber < Base
    class << self
      def clean_phone_number
        phone_number.gsub(/[^\d]/, '')[0..9]
      end
    end
  end

  class Boolean < Base
    class << self
      def random
        rand(2).positive?
      end
    end
  end

  class Years < Base
    class << self
      def random_ago(min_years = 10, max_years = 100)
        years = Faker::Number.random_between(min_years, max_years).years
        days  = Faker::Number.random_between(15, 350).days
        ::Time.current - years + days
      end
    end
  end

  class Months < Base
    class << self
      def random_nr
        rand(1..13)
      end
    end
  end

  class Days < Base
    class << self
      def random_nr
        rand(1..29)
      end
    end
  end

  class Address < Base
    class << self
      def sf_state_abbr
        ::ToolBox::Constants::US_REGION_STATES.sample
      end

      def sf_state
        ::ToolBox::Constants::US_STATES_HASH[sf_state_abbr]
      end
    end
  end
end
