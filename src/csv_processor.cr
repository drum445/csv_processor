require "./csv_processor/*"
require "csv"

class CSVProcessor::CSVP
  getter :records, :headers

  def initialize(@file_name : String)
    @headers = Hash(String, Int32).new
    @records = Array(Array(String)).new
    self.load_headers
  end

  def load_headers
    # load the headers into our hash, it will look like:
    # ["name" => 1] name being the header, 1 being the index
    file = File.read(@file_name)
    csv_reader = CSV::Parser.new(file)

    header_row = csv_reader.next_row

    # need to check for nil otherwise compile error
    unless header_row.nil?
      header_row.each_with_index do |header, index|
        @headers[header] = index
      end
    end
  end

  def read_file
    file = File.read(@file_name)
    csv_reader = CSV::Parser.new(file)

    # skip header row as we have already loaded that in load_headers
    csv_reader.next_row

    # loop through file
    csv_reader.each_row do |row|
      # as we have a headers hash we can retrieve the column we want
      # by using the map of header name/index, example row[@headers["name"]]
      # will return the value of the name column
      @records.push(row)
    end
  end

  def write_file
    result = CSV.build do |csv|
      # build the headers first, which are the keys of the headers hash
      csv.row @headers.keys

      # loop through the records and add each one to the builder
      @records.each do |row|
        csv.row row
      end
    end

    # finally write the built csv object to a new file
    File.write("new_#{@file_name}", result)
  end
end
