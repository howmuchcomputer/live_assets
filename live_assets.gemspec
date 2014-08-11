$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "live_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "live_assets"
  s.version     = LiveAssets::VERSION
  s.authors     = ["dave"]
  s.email       = ["dave@gmail.com"]
  s.homepage    = "http://www.testingit.com"
  s.summary     = "TESTING LIVE ACTION"
  s.description = "TESTING LIVE ACTION"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"
  s.add_dependency "listen"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "puma"
end
