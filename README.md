# Mixpanel API Client                                                                                           

Ruby access to the Mixpanel web analytics tool. [Mixpanel](http://mixpanel.com/]

## Example Usage
    config = {:api_key => 'changeme123', :api_secret => '123changeme'}
    api = Mixpanel::Client.new(config)
    data = api.request(:events, :general, {
      :event    => '["test-event"]',
      :unit     => 'hour',
      :interval =>  24
    })

    puts data.inspect

## Note on Patches/Pull Requests
 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a
   future version unintentionally.
 * Commit, do not mess with rakefile, version, or history.
   (if you want to have your own version, that is fine but
    bump version in a commit by itself I can ignore when I pull)
 * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Keolo Keagy. See LICENSE for details.
