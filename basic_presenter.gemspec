Gem::Specification.new do |s|
  s.name        = "basic_presenter"
  s.version     = '0.0.4'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pikender Sharma", "Hemant Khemani", "Akhil Bansal"]
  s.email       = "info@vinsol.com"
  s.homepage    = "http://vinsol.com"
  s.summary     = "Introduce presenters to your rails app"
  s.description = "A simplified way to glue presenter methods to its domain object"

  s.license = 'MIT'


  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  #s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.extra_rdoc_files = [ 'README.md' ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
  s.add_dependency 'activesupport', '>= 3.0'
end
