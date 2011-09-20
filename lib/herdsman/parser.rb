require 'json'
require 'csv'

class Herdsman::Parser
  DEFAULT_DELIMITER = ' '

  attr_accessor :file, :fields, :delimiter

  def initialize(file, opts)
    self.file = file
    self.fields = opts[:fields]
    self.delimiter = opts[:delimiter] || DEFAULT_DELIMITER
  end

  def read_file
    @read_file ||= File.open(self.file)
  end

  def to_s
    "".tap do |str|
      read_file.each do |line|
        str << JSON.pretty_generate( Hash[*line2arr(line).map.with_index{|val, i| [fields[i], val]}.flatten] )
        str << "\n"
      end
    end
  end

  private

  def line2arr(line)
    # deal with time entry like: [01/Sept/2011:18:00:00 +0000]
    line.gsub!(' [', ' "[')
    line.gsub!('] ', ']" ')

    CSV::parse_line(line, :col_sep => delimiter)
  end
end