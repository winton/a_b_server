class SinatraApp < Sinatra::Base
  
  get "/controller/respond_to/:method" do
    private_methods.include?(params[:method].intern) ? '1' : '0'
  end
  
  get "/helper/respond_to/:method" do
    erb "<%= private_methods.include?(params[:method].intern) ? 1 : 0 %>"
  end
end