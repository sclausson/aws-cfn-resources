require 'rake'

spec = Gem::Specification.new do |s|
  s.name        = 'aws-cfn-resources'
  s.version     = '0.1.1'
  s.date        = '2015-07-09'
  s.summary     = "Simplifies retrieving AWS resource objects created by CloudFormation."
  s.description = "Mixes methods into AWS::CloudFormation::Stack to make it easy to retrieve resource objects created during stack creation."
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Shayne Clausson"]
  s.email       = 'sclausson@hotmail.com'
  s.files       = FileList["lib/*.rb"]
  s.require_paths << 'lib'
  s.required_ruby_version = '>= 1.9.3'
  s.add_development_dependency('rdoc', '~> 4.2')
  s.add_development_dependency('rspec', '3.2.0')
  s.add_runtime_dependency('aws-sdk-v1', '~> 1.64')
  s.homepage    =  'http://github.com/sclausson/aws-cfn-resources'
  s.license     = 'MIT'
end