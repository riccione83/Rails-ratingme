# -*- encoding: utf-8 -*-
# stub: pushmeup 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pushmeup".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nicos Karalis".freeze]
  s.date = "2014-07-26"
  s.description = "                        This gem is a wrapper to send push notifications to devices.\n                        Currently it only sends to Android or iOS devices, but more platforms will be added soon.\n\n                        With APNS (Apple Push Notifications Service) you can send push notifications to Apple devices.\n                        With GCM (Google Cloud Messaging) you can send push notifications to Android devices.\n".freeze
  s.email = ["nicoskaralis@me.com".freeze]
  s.homepage = "https://github.com/NicosKaralis/pushmeup".freeze
  s.rubyforge_project = "pushmeup".freeze
  s.rubygems_version = "2.6.12".freeze
  s.summary = "Send push notifications to Apple devices through ANPS and Android devices through GCM".freeze

  s.installed_by_version = "2.6.12" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<httparty>.freeze, [">= 0"])
      s.add_dependency(%q<json>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>.freeze, [">= 0"])
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
