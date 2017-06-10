# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'gearship'
  spec.version       = '0.1.4' 
  spec.authors       = ['Leonas']
  spec.email         = ['leonas@leonas.io']
  spec.homepage      = 'http://github.com/leonas/gearship'
  spec.summary       = %q{Deploy dockerized projects to virtual machines.}
  spec.description   = %q{Quickly set up a docker host and deploy your app with ease.}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow'
  spec.add_runtime_dependency 'net-ssh'
end
