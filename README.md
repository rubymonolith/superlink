# Superlink

Superlink tames the verbosity of Rails' `link_to`, `*_path`, and `*_url` helpers by providing a more concise, readable, and extensible alternative.

For example, a link that deletes a user from a Rails admin panel might look like this:

```erb
<%= link_to "Delete #{@user.name}", admin_user_path(@user), data_turbo_method: "delete" %>
```

With Superlink, the same link can be written as:

```erb
<%= delete(@user, &:name) %>
```

Assuming the controller has been scoped to the `admin` namespace:

```ruby
class Admin::UsersController < ApplicationController
  def url = super.join("admin")
end
```

Superlink helpers are Ruby objects, which means you can extend them, add your own helper methods, and customize them way beyond Rails url helper methods.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add superlink
```

Then reboot your Rails server.

## Usage

Superlink is still under active development! When its finished, usage instructions will be included here. 🤠

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/superlink. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/superlink/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Superlink project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/superlink/blob/main/CODE_OF_CONDUCT.md).
