# csv_processor

Allows manipulation of CSV files based on header value

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  csv_processor:
    github: drum445/csv_processor
```

## Usage

Using a file that looks like (test.csv):
```
name,age,gender
ed,23,m
bert,42,m
dave,55,m
```

##### Changing a value based on criteria
```crystal
require "csv_processor"

csv = CSVProcessor::CSVP.new("test.csv")
csv.read_file

# assign to h just for shorthand
h = csv.headers

# loop through our records and change the age
# of the record belonging to ed
csv.records.each do |row|
  if row[h["name"]] == "ed"
    row[h["age"]] = "35"
  end
end

# finally write our new records to file
csv.write_file

```

##### Renaming a header
```crystal
csv.rename_header("age", "years")

```

##### Adding a header then setting the value
```crystal
csv.add_header("job")

h = csv.headers
csv.records.each do |row|
  row[h["job"]] = "developer"
end

```

## Contributing

1. Fork it ( https://github.com/drum445/csv_processor/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [drum445](https://github.com/drum445) er - creator, maintainer
