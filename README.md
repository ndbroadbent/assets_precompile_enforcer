# Assets Precompile Enforcer

This gem ensures that developers won't forget to add assets to `config.assets.precompile` while they are developing.
An exception will be raised if you include an asset via `javascript_include_tag` or `stylesheet_link_tag`,
and it doesn't match a filter in `config.assets.precompile`.

## Installation

Add this line to your application's Gemfile, in the `development` group:

    group :development do
      gem 'assets_precompile_enforcer'
    end

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assets_precompile_enforcer

## Usage

You will need to move your `config.assets.precompile += ...` setting into `config/application.rb`, instead of `config/environments/production.rb`. (This setting needs to be shared across development and production.)

You also need to add the following line to `config/environments/development.rb`:

    # Forces included assets to be added to config.assets.precompile
    config.assets.enforce_precompile = true

You can also specify a predicate to be tested when the check is about to be enforced:

    # Forces included assets to be added to config.assets.precompile
    config.assets.enforce_precompile = ->{ !Konacha || Konacha.config.blank? }


You will need to restart your Rails server whenever you make any changes to `config.assets.precompile`.


## Behavior

Whenever you call `javascript_include_tag` or `stylesheet_link_tag` for an asset that doesn't exist in the `config.assets.precompile` array, Rails will throw an error in your development environment:

    <asset file> must be added to config.assets.precompile, otherwise it won't be precompiled for production!

## Ignored assets

If you have any assets that you don't want to precompile for production, then you can ignore them:

    config.assets.ignore_for_precompile = ['development_helpers.js']
  
## Advanced Usage

To avoid restarting your server when you change `config.assets.precompile`, add the following lines to `config/application.rb`:

    # Reload config/assets_precompile when changed
    config.assets.original_precompile = config.assets.precompile.dup
    config.to_prepare { load 'config/assets_precompile.rb' }
    config.watchable_files << 'config/assets_precompile.rb'

Then move your `config.assets.precompile` settings to a new file at `config/assets_precompile.rb`:

    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    assets = Rails.application.config.assets
    assets.precompile = assets.original_precompile + %w( extra_assets.js )

Now you will be able to make changes to `config/assets_precompile.rb` without needing to restart your server.


You can also configure a custom error message so that other developers know where to register their missing assets:

```ruby
config.assets.precompile_error_message_proc = -> asset_file { "#{File.basename(asset_file)} must be added to `config/assets_precompile.rb`, otherwise it won't be precompiled for production!" }
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
