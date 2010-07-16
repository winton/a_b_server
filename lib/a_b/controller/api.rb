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
  
  post '/categories.json' do
    content_type :json
    @user = allow?
    @category = Category.new params[:category]
    @category.user_id = @user.id
    if @user && @category.save
      @category.to_json
    else
      false.to_json
    end
  end
  
  delete '/categories.json' do
    content_type :json
    @user = allow?
    if params[:category] && params[:category][:id]
      @category = @user.categories.find_by_id(params[:category][:id])
    elsif params[:category] && params[:category][:name]
      @category = @user.categories.find_by_name(params[:category][:name])
    end
    if @category
      @category.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/envs.json' do
    content_type :json
    @user = allow?
    @env = Env.new params[:env]
    @env.user_id = @user.id
    if @user && @env.save
      @env.to_json
    else
      false.to_json
    end
  end
  
  delete '/envs.json' do
    content_type :json
    @user = allow?
    if params[:env] && params[:env][:id]
      @env = @user.envs.find_by_id(params[:env][:id])
    elsif params[:env] && params[:env][:name]
      @env = @user.envs.find_by_name(params[:env][:name])
    end
    if @env
      @env.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  get '/sites.json' do
    content_type :json
    @user = allow?
    if @user
      if params[:site] && params[:site][:id]
        @sites = @user.sites.find_by_id(params[:site][:id])
      elsif params[:site] && params[:site][:name]
        @sites = @user.sites.find_by_name(params[:site][:name])
      else
        @sites = @user.sites
      end
    end
    if @sites
      $log.info(symbolize(params[:include]));
      @sites.to_json(
        :include => symbolize(params[:include]),
        :only => symbolize(params[:only])
      )
    else
      false.to_json
    end
  end
  
  delete '/sites.json' do
    content_type :json
    @user = allow?
    if params[:site] && params[:site][:id]
      @site = @user.sites.find_by_id(params[:site][:id])
    elsif params[:site] && params[:site][:name]
      @site = @user.sites.find_by_name(params[:site][:name])
    end
    if @site
      @site.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/sites.json' do
    content_type :json
    @user = allow?
    @site = Site.new params[:site]
    @site.user_id = @user.id
    if @user && @site.save
      @site.to_json(
        :include => symbolize(params[:include]),
        :only => symbolize(params[:only])
      )
    else
      false.to_json
    end
  end
  
  post '/tests.json' do
    content_type :json
    @user = allow?
    category = params[:test].delete('category')
    variants = params[:test].delete('variants')
    category = @user.categories.find_by_name(category)
    ids = {
      :category_id => category.id,
      :site_id => category.site.id,
      :user_id => @user.id
    }
    @test = ABTest.new params[:test].merge(ids)
    if @user && @test.save
      variants.each_with_index do |v, i|
        next if v.empty?
        @test.variants.create({
          :name => v,
          :control => i == 0
        }.merge(ids))
      end
      @test.to_json
    else
      false.to_json
    end
  end
  
  delete '/tests.json' do
    content_type :json
    @test = ABTest.find params[:id]
    if @test && allow?(@test)
      @test.destroy
      true.to_json
    else
      false.to_json
    end
  end
  
  put '/tests.json' do
    content_type :json
    @test = ABTest.find params[:id]
    if @test && allow?(@test)
      @test.update_attributes params[:test]
      true.to_json
    else
      false.to_json
    end
  end
  
  post '/users.json' do
    content_type :json
    if allow_admin?
      User.create(params[:user]).to_json(:except => :admin)
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