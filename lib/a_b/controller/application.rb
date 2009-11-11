Application.class_eval do
  
  before do
    @css = %w(index)
    @js = %w(index)
    @title = 'A/B Test Results'
  end
end