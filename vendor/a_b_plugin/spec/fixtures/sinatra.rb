require 'sinatra/base'

class SinatraApp < Sinatra::Base
  
  get "/controller/respond_to/:method" do
    private_methods.collect(&:to_s).include?(params[:method]) ? '1' : '0'
  end
  
  get "/helper/respond_to/:method" do
    erb "<%= private_methods.collect(&:to_s).include?(params[:method]) ? 1 : 0 %>"
  end
  
  get "/get_cookie" do
    ABPlugin.instance = self
    ABPlugin::Cookies.get('a_b')
  end
  
  get "/set_cookie" do
    ABPlugin.instance = self
    ABPlugin::Cookies.set('a_b', 'test')
    nil
  end
end