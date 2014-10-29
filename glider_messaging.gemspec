# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glider/messaging/version'

Gem::Specification.new do |spec|
  spec.name        = 'glider_messaging'
  spec.version     = Glider::Messaging::VERSION
  spec.authors     = ['Adrian Madrid']
  spec.email       = ['aemadrid@gmail.com']
  spec.summary     = %q{TODO: Write a short summary. Required.}
  spec.description = %q{TODO: Write a longer description. Optional.}
  spec.homepage    = ''
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'ruby-terminfo'

  spec.add_dependency 'bunny', '>= 1.5.1'
  spec.add_dependency 'json', '>= 1.8.1'
  spec.add_dependency 'pry', '>= 0.10.1'

end
