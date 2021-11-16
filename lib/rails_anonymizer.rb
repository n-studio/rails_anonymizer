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

        column_names = model.column_names.select { |column_name| black_list[column_name].present? }
        next if column_names.empty?

        model.in_batches do |batch|
          batch.each do |record|
            column_names.each do |column_name|
              anonymized_value_lambda = black_list[column_name]
              record[column_name] =
                if anonymized_value_lambda.parameters.one?
                  anonymized_value_lambda.call(record)
                else
                  anonymized_value_lambda.call
                end
            end
          end
          model.import(batch.to_ary, on_duplicate_key_update: { columns: column_names }, validate: false)
        end
      end
    end

    def dump
      cmd = nil
      with_config do |app, host, db, user|
        cmd = "pg_dump --host #{host} --username #{user} --verbose " \
              "--clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
      end
      puts cmd
      exec cmd
    end

    def setup
      self.black_list = {}
      yield(RailsAnonymizer)
    end

    private

    # https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90
    def with_config
      yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username]
    end
  end
end
