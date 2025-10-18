# -*- encoding: utf-8 -*-
# stub: bootsnap 1.4.9 ruby lib
# stub: ext/bootsnap/extconf.rb

Gem::Specification.new do |s|
  s.name = "bootsnap".freeze
  s.version = "1.4.9".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "bug_tracker_uri" => "https://github.com/Shopify/bootsnap/issues", "changelog_uri" => "https://github.com/Shopify/bootsnap/blob/master/CHANGELOG.md", "source_code_uri" => "https://github.com/Shopify/bootsnap" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Burke Libbey".freeze]
  s.date = "2020-10-26"
  s.description = "Boot large ruby/rails apps faster".freeze
  s.email = ["burke.libbey@shopify.com".freeze]
  s.extensions = ["ext/bootsnap/extconf.rb".freeze]
  s.files = ["ext/bootsnap/extconf.rb".freeze]
  s.homepage = "https://github.com/Shopify/bootsnap".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Boot large ruby/rails apps faster".freeze

  s.installed_by_version = "3.7.2".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0".freeze])
  s.add_development_dependency(%q<mocha>.freeze, ["~> 1.2".freeze])
  s.add_runtime_dependency(%q<msgpack>.freeze, ["~> 1.0".freeze])
end
