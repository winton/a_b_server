class SinatraApp < Sinatra::Base
  
  get "/controller/respond_to/:method" do
    private_methods.collect(&:to_s).include?(params[:method]) ? '1' : '0'
  end
  
  get "/helper/respond_to/:method" do
    erb "<%= private_methods.collect(&:to_s).include?(params[:method]) ? 1 : 0 %>"
  end
end