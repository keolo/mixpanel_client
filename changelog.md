# Changelog

## 5.0.0

- Removed parallel option in favor of having no runtime dependencies (fixes #58)
- Updated `expect` to use block instead of an argument

## 4.1.6

- Remove deprecated authentication options. Fixes #55
- Use `expect` rspec syntax
- Added codeclimate config

## 4.1.5

- Use new authentication method for mixpanel. Fixes #52
- Use `expect` rspec syntax

## 4.1.4

- Add timeout option: Merged PR #48

## 4.1.3

- Make request options optional. Closes #46

## 4.1.2

- Removes typhoeus version lock, fixes a "broken" test

## 4.1.1

- Add raw response

## 4.1.0

- Drop support for config keys to be strings. Use symbols instead
- Fixed some rubocop offences
- Require Typhoeus when used

## 4.0.1

- Raise ConfigurationError if api_key or api_secret are not present

## 4.0.0

- Dropped support for Ruby 1.8.x
- Code cleanup via rubocop

## 3.1.4

- Updated docs
- Updated to latest typhoeus gem

## 3.1.3

- Added support for the import API
- Allow setting of custom expiry

## v3.1.2

- Gem updates

## 3.1.1

- Avoid overriding the arg of client.request
- Allow retrieving the request_uri of a Mixpanel request

## 3.1.0

- Parallel requests option

## 3.0.0

- NOTE: This version breaks backwards compatibility
- Use a regular ruby hash instead of metaprogramming for mixpanel options

## 2.2.3

- Added some more options

## 2.2.2

- Added some more options

## 2.2.1

- Added support for the raw data export API

## 2.2.0

- BASE_URI is now https
- Changed funnel to funnel_id

## 2.1.0

- Updated json dependency to 1.6

## 2.0.2

- Added timezone to available options
- All exceptions can be caught under `Mixpanel::Error`

## 2.0.1

- Added options used in segmentation resources

## 2.0.0

- Manually tested compatibility with Mixpanel gem

## 2.0.0.beta2

- Added JSON to gemspec for ruby versions less than 1.9

## 2.0.0.beta1

- Reverted to namespacing via module name because it's a better practice.
   I.e. Use `Mixpanel::Client` instead of `MixpanelClient`.
- Added 'values' as an optional parameter
- `gem install mixpanel_client --pre`

## 1.0.1

- Minor housekeeping and organizing
- Refactored specs

## 1.0.0

- Changed "Mixpanel" class name to "MixpanelClient" to prevent naming collision in other
   libraries. [a710a84e8ba4b6f018b7](https://github.com/keolo/mixpanel_client/commit/a710a84e8ba4b6f018b7404ab9fabc8f08b4a4f3)
