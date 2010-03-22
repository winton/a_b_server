Application.class_eval do
  
  get '/a_b.js' do
    data = JSON params[:j]
    identifier = data.delete 'i'
    if variant
      ABRequest.create(
        :data => data,
        :identifier => identifier,
        :ip => request.ip
      )
    end
    "#{params[:callback]}();"
  end
  
  get '/boot.json' do
    restrict
    { :tests => ABTest.find(:all) }.to_json(
      :include => :variants,
      :only => [ :id, :tests, :variants, :name, :visits ]
    )
  end
  
  get '/tests/:id/destroy.json' do
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
    restrict
    @test = ABTest.create params[:test]
    if @test.id
      true.to_json
    else
      false.to_json
    end
  end
  
  get '/variants/:id/destroy.json' do
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