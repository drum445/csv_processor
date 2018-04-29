# csv_processor

Allows manipulation of CSV files based on the columns header<br>Header == Column Name

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

##### Setup
```crystal
require "csv_processor"

csv = CSVProcessor::CSVP.new("test.csv")
csv.read_file
```

##### Changing a value
```crystal
# loop through our records and change the age
# of the record belonging to ed
csv.records.each do |row|
  if row["name"] == "ed"
    row["age"] = "35"
  end
end
```

##### Renaming a column header
```crystal
csv.rename_column("age", "years")
```

##### Adding a column then setting the value
```crystal
csv.add_column("job")

csv.records.each do |row|
  row["job"] = "developer"
end
```

##### Deleting a column
```crystal
csv.delete_column("age")
```

##### Write to file
```crystal
csv.write_file("processed_file.csv")
```

## Contributing

1. Fork it ( https://github.com/drum445/csv_processor/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [drum445](https://github.com/drum445) er - creator, maintainer
