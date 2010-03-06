class SinatraApp < Sinatra::Base
  
  get "/controller/respond_to/:method" do
    private_methods.collect(&:to_s).include?(params[:method]) ? '1' : '0'
  end
  
  get "/helper/respond_to/:method" do
    erb "<%= private_methods.collect(&:to_s).include?(params[:method]) ? 1 : 0 %>"
  end
  
  get "/get_cookie" do
    ABPlugin.instance = self
    ABPlugin::Cookies::Cookie.new['c']['1'].to_s
  end
  
  get "/set_cookie" do
    ABPlugin.instance = self
    cookie = ABPlugin::Cookies::Cookie.new
    cookie['c'] = { 1 => 1 }
    cookie.sync
    nil
  end
end