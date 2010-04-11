Application.class_eval do
  
  get('/') {}
  
  get '/a_b.js' do
    content_type :js
    ip = IP.create_or_increment(request.ip)
    if !ip.limited? && params[:j] && params[:i]
      data = JSON(params[:j])
      visits, conversions = ABVariant.record(data)
      ABRequest.record(params[:i], request, visits, conversions)
    end
    nil
  end
  
  get '/tests.json' do
    content_type :json
    @user = allow?
    @tests = @user ? @user.tests : []
    @tests = { :tests => @tests }
    @tests.to_json(
      :include => :variants,
      :only => [ :id, :tests, :variants, :name, :visits ]
    )
  end
  
  get '/tests/:id/destroy.json' do
    content_type :json
    @test = ABTest.find params[:id]
    if @test && allow?(@test)
      @test.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/tests/:id/update.json' do
    content_type :json
    @test = ABTest.find params[:id]
    if @test && allow?(@test)
      @test.update_attributes params[:test]
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/tests/create.json' do
    content_type :json
    @user = allow?
    @test = ABTest.new params[:test]
    @test.user_id = @user.id
    if @user && @test.save
      true.to_json
    else
      false.to_json
    end
  end
  
  get '/variants/:id/destroy.json' do
    content_type :json
    @variant = ABVariant.find params[:id]
    if @variant && allow?(@variant.test)
      @variant.destroy
      true.to_json
    else
      false.to_json
    end
  end
end