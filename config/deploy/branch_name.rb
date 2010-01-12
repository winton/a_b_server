namespace :branch_name do
  task :mark do
    user = ENV['USER']
    orig_tz = ENV['TZ']
    ENV['TZ'] = 'US/Pacific'
    time = Time.now.strftime("%Y-%m-%d %I:%M:%S %p %Z")
    run %Q{echo "branch : #{branch} #{time} by #{user}" > #{latest_release}/public/branch_name.html}
    ENV['TZ'] = orig_tz
  end
end

after "deploy:update_code", "branch_name:mark"
