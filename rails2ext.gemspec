# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails2ext/version"

Gem::Specification.new do |s|
  s.name        = "rails2ext"
  s.version     = Rails2ext::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["andrea longhi"]
  s.email       = ["andrea@spaghetticode.it"]
  s.homepage    = ""
  s.summary     = %q{some useful extensions for rails 2 apps}
  s.description = %q{some useful extensions for rails 2 apps}

#  s.rubyforge_project = "rails2ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rails', '>= 2.3.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'sqlite3'
end
