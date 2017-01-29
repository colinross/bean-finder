require 'csv'

class LocationImportService
  include ActiveModel::Validations

  Result = ImmutableStruct.new(:records, :errors) do
    def imported?
      errors.empty? && records.present?
    end
  end
  attr_reader :opts

  def initialize(opts: {})
    @opts = opts.with_indifferent_access
  end

  def perform(file:)
    @errors = []
    return ArgumentError unless file.present?
    separator = opts.fetch(:separator, nil) || "\t"
    records = []
    ActiveRecord::Base.transaction do
      begin
      CSV.foreach(file, headers: true, col_sep: separator, skip_blanks: true, header_converters: :symbol) do |row|
        # For the moment, we are doing a straight conversion. This implicitly uses the lat/long virtual attributes.
        # Unknown attributes will throw an UnknownAttributeError exception.
        if opts[:column_attribute_lookup].present?
          records << Location.create!(row.to_hash.transform_keys {|key| column_name_for(key)})
        else
          records << Location.create!(row.to_hash)
        end
      end
      rescue ActiveRecord::UnknownAttributeError => e
        @errors << e.inspect
        rollback!
      rescue CSV::MalformedCSVError => e
        @errors << e.inspect
        rollback!
      end
    end
    Result.new(records: records, errors: @errors)
  end

  protected
  def column_name_for(key)
    return key unless opts[:column_attribute_lookup].present?
    opts[:column_attribute_lookup].fetch(key, key)
  end

  def rollback!
    raise ActiveRecord::Rollback.new(@errors.inspect)
  end

end
