# frozen_string_literal: true

require './lib/mochizuki/version'

Gem::Specification.new do |s|
  s.name        = 'mochizuki'
  s.version     = Mochizuki::VERSION
  s.summary     = 'Tongxinyun Electircity Remaining'
  s.description = 'Get the amount of electricity remaining for dorms, Tongji University'

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7.1'

  s.license = 'MIT'

  s.authors  = ['Kowalski Dark']
  s.email    = ['DarkKowalski2012@gmail.com']
  s.homepage = 'https://github.com/darkkowalski/mochizuki-bot'

  s.files        = Dir['bin/**/*', 'lib/**/*', 'LICENSE', 'README.md']
  s.require_path = 'lib'

  s.bindir      = 'bin'
  s.executables = ['mochizuki']

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/darkkowalski/mochizuki-bot/issues'
  }

  s.add_runtime_dependency 'faraday', '~>1.0.1'
  s.add_runtime_dependency 'nokogiri', '~>1.10.10'
  s.add_runtime_dependency 'rufus-scheduler', '~>3.6.0'
  s.add_runtime_dependency 'telegram-bot-ruby', '~>0.12.0'

  s.add_development_dependency 'ci_reporter_minitest', '~> 1.0.0'
  s.add_development_dependency 'minitest', '~> 5.14.1'
  s.add_development_dependency 'rake', '~> 13.0.1'
end
