namespace :db do
  desc "Anonymize database"
  task anonymize: :environment do
    RailsAnonymizer.anonymize!(force: ENV["FORCE"] == "true", verbose: ENV["VERBOSE"] == "true")
  end

  namespace :anonymize do
    desc "Dump database"
    task dump: :environment do
      RailsAnonymizer.dump
    end

    desc "Restore database"
    task restore: :environment do
      raise "no FILE provided" if ENV["FILE"].blank?

      RailsAnonymizer.restore(ENV["FILE"])
    end
  end
end
