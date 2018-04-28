require "./csv_processor/*"
require "csv"

module CSVProcessor
  class CSVP
    getter records, headers

    def initialize(@file_name : String)
      @headers = Hash(String, Int32).new
      @records = Array(Array(String)).new
      load_headers
    end

    def load_headers
      # load the headers into our hash, it will look like:
      # ["name" => 1] name being the header, 1 being the index
      file = File.read(@file_name)
      csv_reader = CSV::Parser.new(file)

      header_row = csv_reader.next_row

      # need to check for nil
      unless header_row.nil?
        header_row.each_with_index do |header, index|
          @headers[header] = index
        end
      end
    end

    def rename_column(old : String, header : String)
      # find the value of our old header then delete it
      current_index = @headers[old]
      @headers.delete(old)

      # create our new header with the value
      @headers[header] = current_index

      # re-order the headers
      @headers = @headers.to_a.sort_by { |key, value| value }.to_h
    end

    def add_column(header : String)
      # add the header to our headers hash
      @headers[header] = @headers.size

      # add an empty string to each row
      @records.each do |row|
        row.push("")
      end
    end

    def delete_column(header : String)
      # find the index of our target header
      header_index = @headers[header]

      # remove that index from each row
      @records.each do |row|
        row.delete_at(header_index)
      end

      # remove the header
      @headers.delete(header)

      # re-order the headers' value whose value was higher
      # than our deleted header
      @headers.each do |key, value|
        if value > header_index
          @headers[key] -= 1
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

    def write_file(new_file_name : String)
      result = CSV.build do |csv|
        # build the headers first, which are the keys of the headers hash
        csv.row @headers.keys

        # loop through the records and add each one to the builder
        @records.each do |row|
          csv.row row
        end
      end

      # finally write the built csv object to a new file
      File.write(new_file_name, result)
    end
  end
end
