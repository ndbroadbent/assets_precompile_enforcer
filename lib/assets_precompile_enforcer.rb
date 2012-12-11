require "assets_precompile_enforcer/version"

unless defined?(Rake)
  require "assets_precompile_enforcer/sprockets/helpers/rails_helper"
end