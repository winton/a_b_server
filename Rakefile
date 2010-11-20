require File.dirname(__FILE__) + '/lib/a_b_server/gems'

ABServer::Gems.require(:rake)

require 'rake'
require 'active_wrapper/tasks'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

def gemspec
  @gemspec ||= begin
    file = File.expand_path('../a_b_server.gemspec', __FILE__)
    eval(File.read(file), binding, file)
  end
end

if defined?(ActiveWrapper::Tasks)
  ActiveWrapper::Tasks.new(
    :base => File.dirname(__FILE__),
    :env => ENV['ENV']
  )
end

if defined?(Rake::GemPackageTask)
  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end
  task :gem => :gemspec
end

if defined?(Spec::Rake::SpecTask)
  desc "Run specs"
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = %w(-fs --color)
  end
  task :spec
end

namespace :gems do
  desc "Install gems (DEV=1|0 DOCS=1|0 SUDO=1|0)"
  task :install do
    file = File.dirname(__FILE__) + '/gems'
    sudo = (ENV['SUDO'] ||= '0').to_i
    docs = (ENV['DOCS'] ||= '0').to_i
    sudo = sudo == 1 ? 'sudo' : ''
    docs = docs == 1 ? '' : '--no-ri --no-rdoc'
    gems = []
    
    if File.exists?(file)
      File.open(file, 'r') do |f|
        gems = f.readlines.collect do |line|
          line.split(' ')
        end
      end
    else
      gems = ABServer::Gems::TYPES[:gemspec]
      gems = ABServer::Gems::TYPES[:gemspec_dev] if ENV['DEV'] == '1'
      gems.collect! do |g|
        [ g.to_s, ABServer::Gems::VERSIONS[g] ]
      end
    end
    
    gems.each do |(name, version)|      
      if Gem.source_index.find_name(name, version).empty?
        version = version ? "-v #{version}" : ''
        system "#{sudo} gem install #{name} #{version} #{docs}"
      else
        puts "already installed: #{name} #{version}"
      end
    end
  end
end

desc "Install gem locally"
task :install => :package do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}}
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

task :package => :gemspec
task :default => :spec

Dir[File.dirname(__FILE__) + '/tasks/*.rake'].each do |file|
  load(file)
end