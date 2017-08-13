Gem::Specification.new do |s|
  s.name     = "connoisseur"
  s.version  = "1.0.0"
  s.authors  = "George Claghorn"
  s.email    = "georgeclaghorn@gmail.com"
  s.summary  = "Client for the Akismet spam filtering service"
  s.homepage = "https://github.com/georgeclaghorn/connoisseur"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "httparty"

  s.add_development_dependency "rake"
  s.add_development_dependency "activesupport", "~> 5.1.2"
  s.add_development_dependency "minitest"
  s.add_development_dependency "webmock"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
 end
