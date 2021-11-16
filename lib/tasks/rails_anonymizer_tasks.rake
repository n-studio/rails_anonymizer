namespace :db do
  desc "Anonymize database"
  task :anonymize do
    RailsAnonymizer.anonymize!(force: ENV["FORCE"] == "true")
  end

  namespace :anonymize do
    desc "Dump database"
    task :dump do
      RailsAnonymizer.dump
    end
  end
end
