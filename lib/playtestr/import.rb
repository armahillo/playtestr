require 'yaml'

module Playtestr
  class Import
    IMPORT_DIR = './import/'
    attr_reader :data

    # :data :: A ruby collection of card data as an array of hashes
    def initialize(data, filename = 'imported_data', extension = 'csv')
      @data = data
      @filename = filename
      @extension = extension
    end

    def to_yml
      @data.to_yaml
    end

    def to_yml!(filename_override = nil)
      filename_override ||= @filename + '.yml'
      File.open(IMPORT_DIR + filename_override, 'w') do |file|
        file.write(to_yml)
      end
      IMPORT_DIR + filename_override
    end

    def self.from_csv(filename)
      require 'csv'
      csv = CSV.read(filename, headers: true)
      # peel off first record to use as the name
      first_column = csv.first.headers.first
      csv_as_hash = csv.map do |row| 
        row_as_hash = row.to_h
        row_as_hash.reject! {|_,v| v.to_s.strip.empty? }
        [row_as_hash.delete(first_column), row_as_hash]
      end.to_h
      partitioned_filename = File.basename(filename).downcase.gsub(/[^\d\w\-\.]+/,'_').rpartition('.')
      sanitized_filename, extension = partitioned_filename.first, partitioned_filename.last
      new(csv_as_hash, sanitized_filename, extension)
    end
  end
end
