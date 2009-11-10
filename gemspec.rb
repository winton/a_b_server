GEM_NAME = 'a_b'
GEM_FILES = FileList['**/*'] - FileList[
  '*.gem',
  '*.log',
  'config/database.yml',
  'config/deploy.rb',
  'config/mail.yml',
  'coverage',
  'coverage/**/*',
  'log',
  'log/**/*',
  'pkg',
  'pkg/**/*',
  'tmp',
  'tmp/**/*'
]
GEM_SPEC = Gem::Specification.new do |s|
  # == CONFIGURE ==
  s.author = "Winton Welsh"
  s.email = "mail@wintoni.us"
  s.homepage = "http://github.com/winton/#{GEM_NAME}"
  s.summary = "A/B test data aggregator as a Sinatra web service"
  # == CONFIGURE ==
  s.add_dependency('active_wrapper', '=0.2.1')
  s.add_dependency('cucumber', '=0.4.3')
  s.add_dependency('haml', '=2.2.13')
  s.add_dependency('rack', '=1.0.1')
  s.add_dependency('rack-test', '=0.5.1')
  s.add_dependency('rspec', '=1.2.9')
  s.add_dependency('shotgun', '=0.4')
  s.add_dependency('sinatra', '=0.9.4')
  s.add_dependency('webrat', '=0.5.3')
  s.extra_rdoc_files = [ "README.markdown" ]
  s.files = GEM_FILES.to_a
  s.has_rdoc = false
  s.name = GEM_NAME
  s.platform = Gem::Platform::RUBY
  s.require_path = "lib"
  s.version = "0.1.0"
end
