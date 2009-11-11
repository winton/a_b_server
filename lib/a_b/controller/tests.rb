Application.class_eval do
  
  get '/tests/destroy/:id' do
    @test = ABTest.find params[:id]
    if @test
      @test.destroy
      flash[:success] = 'Test deleted successfully.'
    else
      flash[:error] = 'Could not delete test.'
    end
    redirect '/'
  end
  
  post '/tests/new' do
    @test = ABTest.create params[:test]
    if @test.id
      flash[:success] = 'Test created successfully.'
    else
      flash[:error] = 'Could not create test.'
    end
    redirect '/'
  end
end
