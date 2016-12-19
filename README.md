# RuboCop Sequel

Code style checking for Sequel.

## Installation

Using the `rubocop-rspec` gem

```bash
gem install rubocop-sequel
```

or using bundler by adding in your `Gemfile`

```
gem 'rubocop-sequel'
```

## Usage

### RuboCop configuration file

Add to your `.rubocop.yml`.

```
require: rubocop-sequel
```

`rubocop` will now automatically load RuboCop Sequel
cops alongside with the standard cops.

### Command line

```bash
rubocop --require rubocop-sequel
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-sequel'
end
```
