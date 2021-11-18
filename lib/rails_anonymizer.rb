require "rails_anonymizer/version"
require "rails_anonymizer/railtie"
require "activerecord-import"

module RailsAnonymizer
  mattr_accessor :black_list

  class << self
    def anonymize!(force: false)
      unless force || Rails.env.development? || Rails.env.test?
        raise "Warning: use force option to run this command on an environment that is not development or test"
      end

      Rails.application.eager_load!

      models = ApplicationRecord.send(:subclasses)

      models.each do |model|
        next if model.abstract_class?

        model_black_list = black_list.dup
        model_black_list.merge!(black_list[model.to_s]) if black_list[model.to_s].is_a? Hash

        columns_to_anonymize = model.column_names.select { |column_name| model_black_list[column_name].present? }
        next if columns_to_anonymize.empty?

        model.in_batches do |batch|
          batch.each do |record|
            columns_to_anonymize.each do |column_name|
              record[column_name] = anonymize_record_with(record, anonymizer: model_black_list[column_name])
            end
          end
          model.import(batch.to_ary, on_duplicate_key_update: { columns: columns_to_anonymize }, validate: false)
        end
      end
    end

    def dump
      app = Rails.application.class.module_parent_name.underscore
      db = ActiveRecord::Base.connection_db_config.configuration_hash[:database]
      cmd = "pg_dump --verbose " \
            "--clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
      exec cmd
      puts "The database has been dumped to: #{Rails.root}/db/#{app}.dump"
    end

    def restore(file_path)
      db = ActiveRecord::Base.connection_db_config.configuration_hash[:database]
      cmd = "pg_restore --verbose " \
            "--clean --no-owner --no-acl --format=c --dbname=#{db} #{file_path}"
      exec cmd
    end

    def setup
      self.black_list = {}
      yield(RailsAnonymizer)
    end

    private

    def anonymize_record_with(record, anonymizer:)
      if anonymizer.parameters.one?
        anonymizer.call(record)
      else
        anonymizer.call
      end
    end
  end
end
