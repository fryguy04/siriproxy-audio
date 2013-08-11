# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-audio"
  s.version     = "1.0.0"
  s.authors     = ["fryguy"]
  s.email       = [""]
  s.homepage    = "https://github.com/fryguy04/siriproxy-audio"
  s.summary     = %q{SiriProxy plugin to change HAI Whole House Audio}
  s.description = %q{}

  s.rubyforge_project = ""

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency "siriproxy", ">=0.5.2"



end
 
