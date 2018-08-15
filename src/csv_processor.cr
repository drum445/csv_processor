require "./csv_processor/*"
require "csv"

module CSVProcessor
  class CSVP
    getter records, headers

    def initialize(@file_name : String)
      @headers = Array(String).new
      # @records = Array(Array(String)).new
      @records = Array(Hash(String, String)).new
      load_headers
    end

    def load_headers
      # load the headers into our array
      file = File.read(@file_name)
      csv_reader = CSV::Parser.new(file)

      header_row = csv_reader.next_row

      # need to check for nil
      unless header_row.nil?
        @headers = header_row
      end
    end

    def rename_column(old : String, header : String)
      # find the old header and rename it
      @headers.each_with_index do |h, i|
        if h == old
          @headers[i] = header
        end
      end

      # for each row add a new header with the old header's value
      # then delete the old kvp
      @records.each do |row|
        row[header] = row[old]
        row.delete(old)
      end
    end

    def add_column(header : String)
      # add the header to our headers array
      @headers.push(header)

      # add an empty string to each row for the new header
      @records.each do |row|
        row[header] = ""
      end
    end

    def delete_column(header : String)
      # remove that index from each row
      @records.each do |row|
        row.delete(header)
      end

      # remove the header
      @headers.delete(header)
    end

    def read_file
      file = File.read(@file_name)
      csv_reader = CSV::Parser.new(file)

      # skip header row as we have already loaded that in load_headers
      csv_reader.next_row

      # for each row we want a hash that looks like {header => value}
      # once created push it to the records array
      # check that the row is complete, otherwise we will get an indexing error
      csv_reader.each_row do |row|
        if row.size != @headers.size
          next
        end

        row_hash = Hash(String, String).new
        row.each_with_index do |value, index|
          row_hash[@headers[index]] = value
        end
        @records.push(row_hash)
      end
    end

    def write_file(new_file_name : String)
      result = CSV.build do |csv|
        # build the headers first, which is just our headers array
        csv.row @headers

        # loop through each row of our records
        # then for each of our headers add the row value to array
        # then write it to file
        @records.each do |row|
          row_array = Array(String).new
          @headers.each do |header|
            row_array.push(row[header])
          end
          csv.row row_array
        end
      end

      # finally write the built csv object to a new file
      File.write(new_file_name, result)
    end
  end
end
