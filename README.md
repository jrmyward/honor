# Honor
[![Build Status](https://travis-ci.org/jrmyward/honor.png?branch=master)](https://travis-ci.org/jrmyward/honor)

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
bundle install
```

Install and run the migrations:

```shell
rails g honor:install
rake db:migrate
```

## Usage

Honor is meant to be used with a **single model** (eg. User, Employee, Person, Company, etc). At this time, using Honor with multiple models is NOT supported.

```ruby
class User < ActiveRecord::Base
  include Honor
end
```

Honor adds two new relationships to the receiving model.

1. `has_many :points`
2. `has_one :scorecard`

### Points

Points are generally awarded for various User interactions throughout an application. Honor gives you the ability to provide a message as well as a classification to each point block awarded.

```ruby
class User < ActiveRecord::Base
  include Honor
end

@user = User.new

# add points to a user
@user.add_points(25)

# add points to a user with a bit more description
@user.add_points(25, "Awarded for some awesome action", "Social")

# subtract points to a user
@user.subtract_points(25)

# subtract points to a user with a bit more description
@user.subtract_points(25, "Awarded for some awesome action", "Social")

# Quick Accessors for commone point totals
@user.points_total
@user.points_today
@user.points_this_week
@user.points_this_month
@user.points_this_year

# If you're fastidious about keeping business logic categories semantic (same case, same spelling, etc), then you can easily total points for a given point category by passing a string representing the category into any of the accessors above:
@user.points_total("Social") # => returns total for points with a category matcing "Social"

```

There's bond to be situations where you don't have or don't want to instantiate a new "honorable" object (User in the above example), but have access to the User's id....Honorable has you covered. In these cases, Honorable provides class methods similar to the above:

```ruby
# example user id, could come from an array or whatever
user_id = 1

# add points to a user
Honor::Point.give_to(user_id, 25)

# add points to a user with a bit more description
Honor::Point.give_to(user_id, 25, "Awarded for some awesome action", "Social")

# subtract points to a user
Honor::Point.take_from(user_id, 25)

# subtract points to a user with a bit more description
Honor::Point.take_from(user_id, 25, "Awarded for some awesome action", "Social")


# Quick Accessors for commone point totals (does NOT accept a category at this time)
Honor::Point.points_total
Honor::Point.points_today
Honor::Point.points_this_week
Honor::Point.points_this_month
Honor::Point.points_this_year

```

### Scorecards

Every "honorable" object (User in the above examples) has one scorecard that is continually updated whenever a point record is saved. Scorecards keep a running tally of points for:

1. daily
2. weekly
3. monthly
4. yearly
5. lifetime

From these subsets you can quickly and easily make Ranked Leaderboards that complies with the Standard Competition Ranking system. That is, it takes tied positions into account and adjusts ranks accordingly.

```ruby
user_ids = current_user.friend_ids_and_me # => an array of user_ids (eg. [1, 5, 2, 23])
@daily_leaderboard    = Honor::Scorecard.leaderboard(user_ids, rank_by: 'daily', sort_direction: 'desc')
@weekly_leaderboard   = Honor::Scorecard.leaderboard(user_ids, rank_by: 'weekly', sort_direction: 'desc')
@monthly_leaderboard  = Honor::Scorecard.leaderboard(user_ids, rank_by: 'monthly', sort_direction: 'desc')
@yearly_leaderboard   = Honor::Scorecard.leaderboard(user_ids, rank_by: 'yearly', sort_direction: 'desc')
```

Honor provides the Scorecards class with some utility methods useful for setting cron jobs to automate cleaning-up the scorecards.

```ruby
Honor::Scorecard.reset_daily_scores
Honor::Scorecard.reset_weekly_scores
Honor::Scorecard.reset_monthly_scores
Honor::Scorecard.reset_yearly_scores
```

## Testing

Honor uses RSpec for its test coverage. Inside the gem directory, you can run the specs with:

```shell
rake
```

## TODO

- Add Badges / Achievement functionality

## Contributing

1. Fork it
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Add some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create new Pull Request
