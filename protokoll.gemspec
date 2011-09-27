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
  s.summary     = "A simple Rails gem to create custom autoincrement values to a database column"
  s.description = "Rails gem to enable creation of autoincrement Time based string on a model defined by a pattern. Ex: :pattern => 'P%y###' produces: 'P2011001', 'P2011002'..."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_development_dependency "sqlite3"
end
