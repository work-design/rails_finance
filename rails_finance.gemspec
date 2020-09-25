$:.push File.expand_path('lib', __dir__)
require 'rails_finance/version'

Gem::Specification.new do |s|
  s.name = 'rails_finance'
  s.version = RailsFinance::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_finance'
  s.summary = 'Summary of Rails Finance'
  s.description = 'Description of RailsDoc.'
  s.license = 'LGPL-3.0'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails_com', '~> 1.2'
  s.add_dependency 'rails_audit'
  s.add_development_dependency 'sqlite3'
end
