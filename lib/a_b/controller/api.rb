Application.class_eval do
  
  get('/') {}
  
  get '/a_b.js' do
    content_type :js
    ip = IP.create_or_increment(request.ip)
    unless ip.limited?
      data = JSON(params[:j])
      visits, conversions = ABVariant.record(data)
      ABRequest.record(params[:i], request.ip, visits, conversions)
    end
    nil
  end
  
  get '/boot.json' do
    content_type :json
    restrict
    { :tests => ABTest.find(:all) }.to_json(
      :include => :variants,
      :only => [ :id, :tests, :variants, :name, :visits ]
    )
  end
  
  get '/tests/:id/destroy.json' do
    content_type :json
    restrict
    @test = ABTest.find params[:id]
    if @test
      @test.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/tests/:id/update.json' do
    content_type :json
    restrict
    @test = ABTest.find params[:id]
    if @test
      @test.update_attributes params[:test]
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/tests/create.json' do
    content_type :json
    restrict
    @test = ABTest.create params[:test]
    if @test.id
      true.to_json
    else
      false.to_json
    end
  end
  
  get '/variants/:id/destroy.json' do
    content_type :json
    restrict
    @variant = ABVariant.find params[:id]
    if @variant
      @variant.destroy
      true.to_json
    else
      false.to_json
    end
  end
end