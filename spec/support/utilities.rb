module Support
  class Utilities
    # Faker::PhoneNumber.phone_number to replace
    # with well formatted phone number for Simple RTO
    def Utilities.fake_phone
      ActionController::Base.helpers.number_to_phone fake_phone_stripped, area_code: true
    end

    def Utilities.fake_phone_stripped
      [rand(7) + 2, rand(9), rand(9), rand(7) + 2, rand(9), rand(9), rand(9), rand(9), rand(9), rand(9)].map { |x| x.to_s }.join
    end

    def Utilities.auth0_token
      filename        = "#{Rails.root}/spec/files/auth0_token.json"
      read_parse_generate_json(filename)
    end

    private

    def self.read_parse_generate_json(filename)
      # To convert to Hash
      parsed_response = JSON.parse(File.read(filename))
      # To revert to JSON which removes formatting for comparisons
      JSON.generate(parsed_response)
    end
  end
end
