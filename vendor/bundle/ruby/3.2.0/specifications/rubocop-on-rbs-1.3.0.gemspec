# -*- encoding: utf-8 -*-
# stub: rubocop-on-rbs 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-on-rbs".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/ksss/rubocop-on-rbs", "homepage_uri" => "https://github.com/ksss/rubocop-on-rbs", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/ksss/rubocop-on-rbs" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["ksss".freeze]
  s.bindir = "exe".freeze
  s.date = "2024-12-24"
  s.description = "RuboCop extension for RBS file.".freeze
  s.email = ["co000ri@gmail.com".freeze]
  s.homepage = "https://github.com/ksss/rubocop-on-rbs".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "RuboCop extension for RBS file.".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rbs>.freeze, ["~> 3.5"])
  s.add_runtime_dependency(%q<rubocop>.freeze, ["~> 1.61"])
  s.add_runtime_dependency(%q<zlib>.freeze, [">= 0"])
end
