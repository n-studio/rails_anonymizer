ANONYMOUS_PASSWORD = User.new(password: "password").encrypted_password

RailsAnonymizer.setup do |config|
  config.black_list = {
    "email" => -> { Faker::Internet.email },
    "encrypted_password" => -> { ANONYMOUS_PASSWORD },
    "name" => ->(record) { "user_#{record.id}" },
    "address" => -> { Faker::Address.full_address },
    "phone_number" => -> { "+33333333333" },
  }
end
