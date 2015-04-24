Gem::Specification.new do |s|
  s.name        = "xcode-translation-tool"
  s.version     = "0.1.0"
  s.authors     = ["Dirk Eisenberg"]
  s.email       = "dirk.eisenberg@gmail.com"
  s.description = "XCode Translation Helper"
  s.summary     = "Collection of tools to manage base translation"
  s.homepage    = "https://github.com/dei79/xctt"
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.executables = ['xt-tool']

  s.required_ruby_version = '>= 2.0.0'
end
