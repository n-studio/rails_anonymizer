require_relative "lib/rails_anonymizer/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_anonymizer"
  spec.version     = RailsAnonymizer::VERSION
  spec.authors     = ["Matthew Nguyen"]
  spec.email       = ["contact@n-studio.fr"]
  spec.homepage    = "https://github.com/n-studio"
  spec.summary     = "Anonymize Rails DB."
  spec.description = "Anonymize Rails DB."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/n-studio"
  spec.metadata["changelog_uri"] = "https://github.com/n-studio"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activerecord-import"
  spec.add_dependency "rails", ">= 7.0"
end
