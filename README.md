# Honor

Honor adds support for common gamification features such as points, leaderboards, and achievements.

## Overview

Honor allows you to easily integrate points, rankings, and leaderboards into your Rails application.

## Installation

To use Honor, first add it to you Gemfile:

```ruby
 gem 'honor'
```

And then intall it with bundler by executing:

```shell
bundle
```

Install and run the migrations:

```shell
rails g honor:install
rails db:migrate
```

## Usage

Honor is meant to be used with a **single model** (eg. User, Employee, Person, Company, etc). At this time, using Honor with multiple models is NOT supported.

```ruby
class User < ActiveRecord::Base
  include Honor
end
```

## Testing

Honor uses RSpec for its test coverage. Inside the gem directory, you can run the specs with:

```shell
rake
```

## Contributing

1. Fork it
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Add some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create new Pull Request
