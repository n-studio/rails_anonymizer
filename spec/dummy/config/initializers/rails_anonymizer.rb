Rails.application.config.to_prepare do
  module RailsAnonymizerConfig
    begin
      ANONYMOUS_PASSWORD = User.new(password: "password").encrypted_password
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid => _e
    end
  end

  RailsAnonymizer.setup do |config|
    config.black_list = {
      "email" => -> { Faker::Internet.unique.email },
      "encrypted_password" => -> { RailsAnonymizerConfig::ANONYMOUS_PASSWORD },
      "name" => ->(record) { "user_#{record.id}" },
      "Admin" => {
        "address" => -> { Faker::Address.full_address },
      },
      "User" => {
        "phone_number" => -> { "+33333333333" },
      },
    }
  end
end
