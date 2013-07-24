# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  
  s.name = 'pg-xml'
  s.version = '0.0.1'

  s.description = "postgresql xml datatype support for activerecord -- heavily based on pg-hstore and activerecord-postgres-hstore"
  s.summary     = "postgresql xml datatype support for activerecord -- heavily based on pg-hstore and activerecord-postgres-hstore"

  s.authors = ["Kai Stinchcombe"]
  s.email = ["k@i.stinchcom.be"]

  s.files = Dir['lib/*.rb'] + Dir['lib/pg-xml/*.rb']

  # s.add_development_dependency 'rspec'
  s.add_development_dependency 'pg'
  # s.homepage = "https://github.com/seamusabshere/pg-hstore"
  s.require_paths = ['lib', 'lib/pg-xml']
  
end
