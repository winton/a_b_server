# chef hook for eycloud env

if %w(app_master app util solo).include?(node[:instance_role])
  # gems for app
  sudo "cd #{latest_release} && rake gems:install SUDO=1 DOCS=0"
end