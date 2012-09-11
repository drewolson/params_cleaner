# -*- encoding: utf-8 -*-
require File.expand_path("../lib/params_cleaner/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Drew Olson"]
  gem.email         = ["drew@drewolson.org"]
  gem.description   = %q{Rails mass assignment protection in the controller}
  gem.summary       = %q{Rails mass assignment protection in the controller}
  gem.homepage      = "https://github.com/drewolson/params_cleaner"

  gem.files         = Dir.glob("lib/**/*.rb")
  gem.name          = "params_cleaner"
  gem.require_paths = ["lib"]
  gem.version       = ParamsCleaner::VERSION

  gem.add_dependency  "activesupport", ">= 3.0.0"
end
