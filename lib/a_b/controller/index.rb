Application.class_eval do
  get '/' do
    haml :index
  end
end
