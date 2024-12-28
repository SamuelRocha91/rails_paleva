# -*- encoding: utf-8 -*-
# stub: rubocop-discourse 3.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-discourse".freeze
  s.version = "3.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Discourse Team".freeze]
  s.date = "2024-05-27"
  s.homepage = "https://github.com/discourse/rubocop-discourse".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Custom rubocop cops used by Discourse".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.1"])
  s.add_runtime_dependency(%q<rubocop>.freeze, [">= 1.59.0"])
  s.add_runtime_dependency(%q<rubocop-rspec>.freeze, [">= 2.25.0"])
  s.add_runtime_dependency(%q<rubocop-factory_bot>.freeze, [">= 2.0.0"])
  s.add_runtime_dependency(%q<rubocop-capybara>.freeze, [">= 2.0.0"])
  s.add_runtime_dependency(%q<rubocop-rails>.freeze, [">= 2.25.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.1.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.12.0"])
end
