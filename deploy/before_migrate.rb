# chef hook for eycloud env

if %w(app_master app util solo).include?(node[:instance_role])
  # prerequire gems for require
  sudo "gem install active_wrapper --version='0.2.4' --no-ri --no-rdoc"
  sudo "gem install rake --version=0.8.7 --no-ri --no-rdoc"
  sudo "gem install rspec --version=1.3.0 --no-ri --no-rdoc"
  sudo "gem install require --no-ri --no-rdoc"
  
  # gems for app
  sudo "rake gems:install SUDO=1 DOCS=0"
end