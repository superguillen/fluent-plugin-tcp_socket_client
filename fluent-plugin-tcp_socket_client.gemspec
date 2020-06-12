# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-tcp_socket_client"
  gem.description = "Input plugin for Fluent, reads from TCP socket"
  gem.homepage    = "https://github.com/superguillen/fluent-plugin-tcp_socket_client"
  gem.summary     = gem.description
  gem.version     = "0.0.1"
  gem.authors     = ["superguillen"]
  gem.email       = "superguillen.public@gmail.com"
  gem.has_rdoc    = false
  gem.license     = 'MIT'
  gem.files       = Dir['Rakefile', '{lib}/**/*', 'README*', 'LICENSE*']
  gem.require_paths = ['lib']

  gem.add_dependency "fluentd", [">= 0.10.58", "< 2"]
  gem.add_development_dependency "rake", ">= 0.9.2"
  gem.add_development_dependency "test-unit", ">= 3.0.8"
end
