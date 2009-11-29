require 'rubygems'

gems = [
  [ 'cucumber', '=0.4.4' ],
  [ 'rspec', '=1.2.9' ],
  [ 'active_wrapper', '=0.2.2' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'rake'
require 'active_wrapper/tasks'
require 'cucumber/rake/task'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'gemspec'

ActiveWrapper::Tasks.new(
  :base => File.dirname(__FILE__),
  :env => ENV['ENV']
)

desc "Generate gemspec"
task :gemspec do
  File.open("#{Dir.pwd}/#{GEM_NAME}.gemspec", 'w') do |f|
    f.write(GEM_SPEC.to_ruby)
  end
end

desc "Install gem"
task :install do
  Rake::Task['gem'].invoke
  `sudo gem uninstall #{GEM_NAME} -x`
  `sudo gem install pkg/#{GEM_NAME}*.gem`
  `rm -Rf pkg`
end

desc "Package gem"
Rake::GemPackageTask.new(GEM_SPEC) do |pkg|
  pkg.gem_spec = GEM_SPEC
end

desc "Rename project"
task :rename do
  name = ENV['NAME'] || File.basename(Dir.pwd)
  begin
    dir = Dir['**/gem_template*']
    from = dir.pop
    if from
      rb = from.include?('.rb')
      to = File.dirname(from) + "/#{name}#{'.rb' if rb}"
      FileUtils.mv(from, to)
    end
  end while dir.length > 0
  Dir["**/*"].each do |path|
    next if path.include?('Rakefile')
    if File.file?(path)
      `sed -i "" 's/gem_template/#{name}/g' #{path}`
    end
  end
end

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.rcov = true
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end