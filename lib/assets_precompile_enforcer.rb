require "assets_precompile_enforcer/version"

# Needs to be disabled for Konacha
unless defined?(Konacha)
  require "assets_precompile_enforcer/sprockets/helpers/rails_helper"
end
