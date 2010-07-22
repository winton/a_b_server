# chef hook for eycloud env

def do_symlinks(folder)
  normal_symlinks = %w(
    config/database.yml
    config/newrelic.yml
    config/lilypad.txt
  )
  commands = []
  commands << normal_symlinks.map do |path|
    "rm -rf #{folder}/#{path} && \
     ln -sf #{shared_path}/#{path} #{folder}/#{path}"
  end
  run <<-CMD
    cd #{folder} &&
    #{commands.join(" && ")}
  CMD
end

if %w(app_master app util solo).include?(node[:instance_role])
  # gems for app
  sudo "cd #{latest_release} && bundle install"

  sudo 'if gem list | grep rack | grep 1.1.0; then gem uninstall rack --version=1.1.0; else echo "dont need to uninstall rack version=1.1.0"; fi'

  # symlinks
  do_symlinks(latest_release)
end