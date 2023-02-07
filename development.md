# Development

Workspace options:

1. Work within [Codespaces](https://github.com/features/codespaces)
2. Work locally
	- `cd` to a working directory for this project
	- `git clone [REPOSITORY URL]`

Setup and make changes:

- Install dependencies with `bundle install`
- Try `rake -T` to see available commands
- Try `rake spec` to run the unit tests
- Make code and test changes

Verify quality:

- Verify code quality using `rubocop`
- Verify specs pass
- Run manual tests `lib/mixpanel/manual_test/basic.rb`

Build and release gem:

- Run `rake build` to build the gem into the pkg directory
- Run `rake release` to build and release to rubygems
