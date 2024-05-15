![CI status](https://github.com/rubocop/rubocop-sequel/workflows/CI/badge.svg)

# RuboCop Sequel

Code style checking for [Sequel ORM](https://sequel.jeremyevans.net/).

## Installation

You can install the `rubocop-sequel` gem using either of the following methods:

### Via RubyGems

Run this command in your terminal:

```bash
gem install rubocop-sequel
```

### Using Bundler

Add this line to your project's Gemfile:

```ruby
gem 'rubocop-sequel'
```

Then, execute:

```bash
bundle install
```

## Usage

### Configuring RuboCop

To integrate RuboCop Sequel into your project, add the following line to your
`.rubocop.yml` configuration file:

```yaml
require: rubocop-sequel
```

This configuration instructs RuboCop to automatically load the RuboCop Sequel cops
along with the standard set, enhancing your project's code analysis with
Sequel-specific checks.

### Running from the Command Line

Invoke RuboCop with the `rubocop-sequel` requirement to analyze your project's files:

```bash
rubocop --require rubocop-sequel
```

## Testing with RuboCop Sequel Cops

The rubocop-sequel gem includes several cops that enforce best practices for using
Sequel. These cops are designed to catch common errors and guide developers towards
more efficient and maintainable code patterns. Below are examples of some key cops
and how they improve your Sequel code:

 - `Sequel::SaveChanges` - Ensures the use of save_changes instead of save to persist
   changes to models.
 - `Sequel::JSONColumn` - Advocates the use of the `jsonb` column type over `json` or
   `hstore` for performance benefits and additional functionality.
 - `Sequel::ConcurrentIndex` - Encourages the creation of indexes with the
   `NOT VALID` option to avoid locking tables.
 - `Sequel::PartialConstraint` - Advises on the correct use of partial indexes by
    specifying the `where' argument.
 - `Sequel::NotValidConstraint` - Suggests adding constraints with the
   `not_valid: true` option for safer migrations.
 - `Sequel::MigrationName` - Helps to name migration files descriptively in order to
    avoid the use of default or generic names.

By incorporating these and other Sequel-specific cops into your RuboCop checks, you
can significantly improve the quality and reliability of your database interactions.

## Contribution

Contributions to the `rubocop-sequel` project are welcome! Whether it's adding new
cops, improving existing ones, or fixing bugs, your help is appreciated in making
this gem more useful for the Ruby and Sequel communities.
