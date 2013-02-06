# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facwparser/version'

Gem::Specification.new do |gem|
  gem.name          = "facwparser"
  gem.version       = Facwparser::VERSION
  gem.authors       = ["HARUYAMA Seigo"]
  gem.email         = ["haruyama@unixuser.org"]
  gem.description   = %q{Fuxxing Atlassian Confluence Wiki Parser}
  gem.summary       = %q{Parser of Atlassian Confluence Wiki Markup.}
  gem.homepage      = "https://github.com/haruyama/facwparser"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
