# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/sq_ci_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-sq_ci_tools'
  spec.version       = Fastlane::SqCiTools::VERSION
  spec.author        = 'Semen Kologrivov'
  spec.email         = 'semen@sequenia.com'

  spec.summary       = 'CI Library for sequenia\'s projects'
  spec.homepage      = "https://github.com/sequenia/fastlane-plugin-sq_ci_tools"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'false'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency
  
  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.222.0')
end
