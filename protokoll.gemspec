$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "protokoll/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "protokoll"
  s.version     = Protokoll::VERSION
  s.authors     = ["Celso Dantas"]
  s.email       = ["celsodantas@gmail.com"]
  s.homepage    = "https://github.com/celsodantas/protokoll"
  s.summary     = "A simple Rails gem to create custom autoincrement Time base values to a database column"
  s.description = "Rails 4 gem to enable creation of a custom autoincrement Time based string on a model defined by a pattern. ex. 20110001, 20110002, 20110003, 20120001, 20120002..." 
  s.license = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency("rails", "~> 4.0", "> 4.0")

  s.add_development_dependency "sqlite3", '~> 1'
end
