RailsAnonymizer.setup do |config|
  config.black_list = {
    "email" => -> { Faker::Internet.email },
    "address" => -> { Faker::Address.full_address },
    "name" => -> { Faker::Name.name },
    "phone_number" => -> { "+33333333333" },
  }
end