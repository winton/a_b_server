# chef hook for eycloud env

if %w(app_master app util).include?(node[:instance_role])
  sudo "rake gems:install SUDO=1 DOCS=0"
end