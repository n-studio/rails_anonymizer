# RailsAnonymizer
Anonymize your DB.

## Usage
* Setup your blacklist in the initializer
* Dump your prod DB on a local environment with `bin/rails db < prod.sql`
* Run `bin/rails db:anonymize`
* Dump your anonymized DB with `bin/rails db:anonymize:dump` (currently works only for postgresql, PR to support other DBs welcome)

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
