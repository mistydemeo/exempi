# -*- encoding: utf-8 -*-
require File.expand_path('../lib/exempi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Misty De Meo"]
  gem.email         = ["mistydemeo@gmail.com"]
  gem.description   = <<-EOS
                      Exempi is a thin FFI-based wrapper around the
                      Exempi library. It provides a variety of
                      functions for reading, writing, and manipulating
                      XMP metadata.
                      EOS
  gem.summary       = %q{Ruby wrapper for Exempi}
  gem.homepage      = "https://github.com/mistydemeo/exempi"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "exempi"
  gem.require_paths = ["lib"]
  gem.version       = Exempi::VERSION

  gem.add_dependency 'ffi', '>= 1.1.5'

  gem.add_development_dependency 'rake', '>= 0.9.2.2'
end
