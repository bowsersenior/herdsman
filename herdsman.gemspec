# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "herdsman/version"

Gem::Specification.new do |s|
  s.name        = "herdsman"
  s.version     = Herdsman::VERSION
  s.authors     = ["Mani Tadayon"]
  s.email       = ["bowsersenior@gmail.com"]
  s.homepage    = "https://github.com/bowsersenior/herdsman"
  s.summary     = "herdsman-#{s.version}"
  s.description = %q{The herdsman parses and organizes log files using MongoDB.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "cucumber", "~> 1.0"
  s.add_development_dependency "aruba", "~> 0.4"

  s.add_runtime_dependency "mongo", "~> 1.3"
end