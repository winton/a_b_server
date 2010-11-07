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
      :json => params[:j],
      :referer => request.env["HTTP_REFERER"]
    ]
    'a_b_finished();'
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
  
  put '/categories.json' do
    content_type :json
    @user = allow?
    if @user
      @category = @user.categories.find_by_id params[:category][:id]
      if @category.update_attributes(params[:category])
        @category.to_json
      else
        false.to_json
      end
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
  
  put '/envs.json' do
    content_type :json
    @user = allow?
    if @user
      @env = @user.envs.find_by_id params[:env][:id]
      if @env.update_attributes(params[:env])
        @env.to_json
      else
        false.to_json
      end
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
        @sites = Site.find_by_id(params[:site][:id])
      elsif params[:site] && params[:site][:name]
        @sites = Site.find_by_name(params[:site][:name])
      else
        @sites = @user.sites
      end
    end
    if @sites.respond_to?(:user_id) && !@user.admin? && @sites.user_id != @user.id
      @sites = nil
    end
    if @sites
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
  
  put '/sites.json' do
    content_type :json
    @user = allow?
    @site = Site.find_by_id params[:site][:id]
    if @user && @site && (@site.user_id == @user.id || allow_admin?)
      @site.update_attributes params[:site]
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
      @test.reload.to_json(
        :include => symbolize(params[:include]),
        :only => symbolize(params[:only])
      )
    else
      false.to_json
    end
  end
  
  put '/tests.json' do
    content_type :json
    @user = allow?
    if @user
      @test = @user.tests.find_by_id params[:test][:id]
      if @test
        @test.update_attribute :name, params[:test][:name]
        @test.variants.each_with_index do |variant, i|
          old_variant = params[:test][:old_variants][variant.id.to_s]
          if old_variant && old_variant.empty?
            if variant.control?
              if @test.variants[i+1]
                @test.variants[i+1].update_attribute :control, true
                variant.destroy
              end
            else
              variant.destroy
            end
          elsif old_variant && old_variant != variant.name
            variant.update_attribute :name, old_variant
          end
        end
        params[:test][:variants].each do |variant|
          next if variant.empty?
          @test.variants.create({
            :name => variant,
            :control => false,
            :category_id => @test.category_id,
            :site_id => @test.site_id,
            :test_id => @test.id,
            :user_id => @user.id
          })
        end
        @test.reload.to_json(
          :include => symbolize(params[:include]),
          :only => symbolize(params[:only])
        )
      else
        false.to_json
      end
    else
      false.to_json
    end
  end
  
  delete '/tests.json' do
    content_type :json
    @test = ABTest.find params[:test][:id]
    if @test && allow?(@test)
      @test.destroy
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
  
  post '/variants/:id/reset.json' do
    content_type :json
    @variant = Variant.find params[:id]
    if @variant && allow?(@variant.test)
      @variant.update_attribute(:data, nil)
      @variant.to_json(
        :include => symbolize(params[:include]),
        :only => symbolize(params[:only])
      )
    else
      false.to_json
    end
  end
end