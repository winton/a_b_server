Application.class_eval do
  
  get '/sessions/new' do
    @css = %w(log_in)
    haml :log_in, :layout => :layout
  end
  
  post '/sessions/create' do
    @user_session = UserSession.new(params[:session])
    if @user_session.save
      flash[:success] = "Logged in successfully."
      redirect '/'
    else
      flash[:error] = "Log in failed."
      redirect '/sessions/new'
    end
  end
  
  get '/sessions/destroy' do
    current_user_session.destroy
    flash[:success] = "Logged out successfully."
    redirect '/sessions/new'
  end
  
  get '/css/log_in.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :log_in
  end
end