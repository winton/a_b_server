Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
    end
    
    get '/spec' do
      @user = User.find_or_create_by_identifier('test')
      @site = Site.find_by_name('test').destroy rescue
      @site = Site.create(:name => 'test', :user_id => @user.id)
      
      Env.create(:name => 'development', :user_id => @user.id, :site_id => @site.id)
      
      Variant.delete(2)
      Variant.connection.insert("INSERT INTO variants (id, name, site_id, user_id) VALUES (2, 'test', #{@site.id}, #{@user.id})")
      
      haml :spec, :layout => false
    end
  end
end