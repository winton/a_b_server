Application.class_eval do
  
  get('/') {}
  
  get '/a_b.js' do
    content_type :js
    Delayed::Job.enqueue Job::Increment[
      :agent => request.env["HTTP_USER_AGENT"],
      :date => Date.today,
      :env => params[:e],
      :identifier => params[:i],
      :ip => request.ip,
      :json => params[:j]
    ]
    nil
  end
  
  get '/categories.json' do
    content_type :json
    @user = allow?
    if @user
      @user.categories.to_json(
        :include => [ :tests, :variants ],
        :only => [ :id, :category_id, :name, :tests, :variants ]
      )
    else
      {}.to_json
    end
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
    @variant = Variant.find params[:id]
    if @variant && allow?(@variant.test)
      @variant.destroy
      true.to_json
    else
      false.to_json
    end
  end
end