Application.class_eval do
  
  get '/boot.json' do
    content_type :json
    restrict
    {
      :tests => ABTest.find(:all)
    }.to_json(
      :include => :variants,
      :only => [ :id, :tests, :variants, :name, :visits ]
    )
  end
  
  get '/a_b.js' do
    content_type 'application/javascript'
    data = JSON(params[:j])
    identifier = data.delete('i')
    ABRequest.create(
      :data => data,
      :identifier => identifier,
      :ip => request.ip
    )
    "#{params[:callback]}();"
  end
end