Obscenity.configure do |config|
  config.blacklist   = "config/international.yml"
  config.replacement = :stars
end