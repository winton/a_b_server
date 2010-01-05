# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com
require "eycap/recipes"

#########################################################################
# Library files : has callbacks
load 'config/deploy/branch_name'
load 'config/deploy/migrate'

# Callbacks: some are defined in config/deploy/*.rb files
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"

#########################################################################
# Cap variables
set :keep_releases, 5
set :application,   'a_b'
set :repository,    "git@github.com:winton/a_b.git"
set :deploy_to,     "/data/#{application}"
set :monit_group,   "#{application}"
set :scm,           :git
set :deploy_via, :remote_cache

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:keys] = ["~/.ssh/id_rsa-flex-br"]
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

set :branch, ENV['BRANCH'] || 'master'
task :fake_production do
  production
end

task :production do  
  role :web, '174.129.29.84'
  role :app, '174.129.29.84'
  role :db, '174.129.29.84', :primary => true

  set :rack_env, "production"
  set :environment_database, Proc.new { 'a_b_production' }
  set :user,          'deploy'
  set :runner,        'deploy'
end

task :staging do  
  role :web, '75.101.153.241'
  role :app, '75.101.153.241'
  role :db, '75.101.153.241', :primary => true

  set :rack_env, "staging"
  set :environment_database, Proc.new { 'a_b_staging' }
  set :user,          'deploy'
  set :runner,        'deploy'
end

namespace :nginx do
  task :start, :roles => :app do
    sudo "nohup /etc/init.d/nginx start > /dev/null"
  end

  task :restart, :roles => :app do
    sudo "nohup /etc/init.d/nginx restart > /dev/null"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
    # Do nothing.
  end
 
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
