require File.expand_path("../lib/rspec-live/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "rspec-live"
  s.version = RSpecLive::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Brian Auton"]
  s.email = ["brianauton@gmail.com"]
  s.homepage = "http://github.com/brianauton/rspec-live"
  s.summary = "Continually updating console output for RSpec 3+"
  s.license = "MIT"
  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir.glob("lib/**/*") + ["README.md", "History.md", "License.txt"]
  s.require_path = "lib"
  s.executables = ["rspec-live"]
  s.add_dependency "rspec", "~> 3.0.0"
end
