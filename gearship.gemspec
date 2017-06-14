# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'gearship'
  spec.version       = '0.2.4' 
  spec.authors       = ['Leonas']
  spec.email         = ['leonas@leonas.io']
  spec.homepage      = 'http://github.com/leonas/gearship'
  spec.summary       = %q{Deploy dockerized projects to virtual machines.}
  spec.description   = %q{Quickly set up a docker host and deploy your app with ease.}
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0")

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'rainbow', '~> 2.2'
  spec.add_runtime_dependency 'net-ssh', '~> 4'
end
