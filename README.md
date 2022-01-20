# RailsAnonymizer
Anonymize your DB.

## Usage
* Setup your blacklist in the initializer
* Restore your prod DB on a local environment with `bin/rails db:anonymize:restore FILE=prod.dump`
* Run `bin/rails db:anonymize`
* Dump your anonymized DB with `bin/rails db:anonymize:dump` (currently works only for postgresql, PR to support other DBs welcome)

### Example of initializer

```ruby
# config/initializers/rails_anonymizer.rb
begin
  ANONYMOUS_PASSWORD = User.new(password: "password").encrypted_password
rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid => e
end

RailsAnonymizer.setup do |config|
  config.before do
    # run some code before anonymizing
  end

  config.after do
    # run some code after anonymizing
  end

  config.black_list = {
    "email" => -> { Faker::Internet.unique.safe_email },
    "encrypted_password" => -> { ANONYMOUS_PASSWORD },
    "name" => ->(record) { "customer_#{record.id}" },
    "address" => -> { Faker::Address.full_address },
    "User" => {
      "phone_number" => -> { "+33333333333" },
    },
  }
end
```

### Skip model
If you want to skip a model, add the class method `skip_anonymizer?` to the model and make it return `true`.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_anonymizer'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_anonymizer
```

## Contributing
PRs welcome.  
This gem depends on Rails, but we could imagine a version of it that only depends on ActiveRecord or even just read and write directly into the SQL file. Feel free to suggest a PR that does that.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
