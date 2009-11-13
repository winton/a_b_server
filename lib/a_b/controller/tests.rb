Application.class_eval do
  
  get '/tests/:id/destroy' do
    restrict
    @test = ABTest.find params[:id]
    if @test
      @test.destroy
      flash[:success] = 'Test deleted successfully.'
    else
      flash[:error] = 'Could not delete test.'
    end
    redirect '/'
  end
  
  post '/tests/:id/update' do
    restrict
    @test = ABTest.find params[:id]
    if @test
      @test.update_attributes params[:test]
      flash[:success] = 'Test updated successfully.'
    else
      flash[:error] = 'Could not update test.'
    end
    redirect '/'
  end
  
  post '/tests/create' do
    restrict
    @test = ABTest.create params[:test]
    if @test.id
      flash[:success] = 'Test created successfully.'
    else
      flash[:error] = 'Could not create test.'
    end
    redirect '/'
  end
end
