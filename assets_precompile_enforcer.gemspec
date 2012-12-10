# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assets_precompile_enforcer/version'

Gem::Specification.new do |gem|
  gem.name          = "assets_precompile_enforcer"
  gem.version       = AssetsPrecompileEnforcer::VERSION
  gem.authors       = ["Nathan Broadbent"]
  gem.email         = ["nathan.f77@gmail.com"]
  gem.description   = %q{Raises an exception if assets are missing from config.assets.precompile during development}
  gem.summary       = %q{Enforces config.assets.precompile in development}
  gem.homepage      = "https://github.com/ndbroadbent/assets_precompile_enforcer"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
