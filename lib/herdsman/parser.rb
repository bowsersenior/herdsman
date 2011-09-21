require 'json'
require 'csv'

class Herdsman::Parser
  DEFAULT_DELIMITER = ' '

  attr_accessor :file, :fields, :delimiter

  class FieldCountMismatch < StandardError
  end

  def initialize(file, opts)
    self.file = file
    self.fields = opts[:fields]
    self.delimiter = opts[:delimiter] || DEFAULT_DELIMITER
  end

  # Return an array of strings, one for each line in the file
  def read_file
    @read_file ||= File.open(self.file)
  end

  def to_array
    @to_array ||= [].tap do |arr|
      read_file.each do |line|
        arr << parse_hash_from(line)
      end
    end
  end

  def to_s
    self.to_array.map{ |hsh| JSON.pretty_generate(hsh) }.join("\n")
  end


  private

  def parse_hash_from(line)
    Hash[* add_fields_to_array(line2arr(line)) ]
  end

  def add_fields_to_array(arr)
    if fields.size != arr.size
      raise FieldCountMismatch.new("Expected #{arr.size} fields, got #{fields.size}.")
    end

    arr.map.with_index do |val, i|
      [fields[i], val]
    end.flatten
  end

  def line2arr(line)
    # deal with time entry like: [01/Sept/2011:18:00:00 +0000]
    line.gsub!(' [', ' "[')
    line.gsub!('] ', ']" ')

    CSV::parse_line(line, :col_sep => delimiter)
  end
end