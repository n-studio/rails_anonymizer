require "rails_anonymizer/version"
require "rails_anonymizer/railtie"

module RailsAnonymizer
  mattr_accessor :black_list

  def self.anonymize!(force: false)
    unless force || Rails.env.development? || Rails.env.test?
      raise "Warning: use force option to run this command on an environment that is not development or test"
    end

    models = ApplicationRecord.send(:subclasses)

    models.each do |model|
      next if model.abstract_class?

      model.column_names.each do |column_name|
        if black_list[column_name]
          model.update(model.pluck(:id), Array.new(model.count) { { column_name => black_list[column_name].call } })
        end
      end
    end
  end

  def self.setup
    self.black_list = {}
    yield(RailsAnonymizer)
  end
end
