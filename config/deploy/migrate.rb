# override capistrano's deploy:migrate because we need to use RACK_ENV vs RAILS_ENV
namespace :deploy do
  task :migrate, :roles => :db, :only => { :primary => true } do
    run "cd #{latest_release}; rake RACK_ENV=#{rack_env} db:migrate"
  end
end