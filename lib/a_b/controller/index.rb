Application.class_eval do
  get '/' do
    @css = %w(index)
    @js = %w(index)
    @title = 'A/B Test Results'
    haml :index, :layout => :layout
  end
end
