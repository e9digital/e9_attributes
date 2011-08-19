# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "e9_attributes/version"

Gem::Specification.new do |s|
  s.name        = "e9_attributes"
  s.version     = E9Attributes::VERSION
  s.authors     = ["Travis Cox"]
  s.email       = ["numbers1311407@gmail.com"]
  s.homepage    = "http://github.com/e9digital/e9_attributes"
  s.summary     = %q{Searchable attributes}
  s.description = File.open('README.md').read rescue nil

  s.rubyforge_project = "e9_attributes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
