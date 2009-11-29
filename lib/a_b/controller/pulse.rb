Application.class_eval do
  
  get '/pulse' do
    rows = ActiveRecord::Base.connection.execute("select 1 from dual").num_rows rescue 0
    rows == 1 ? "OK" : "Error!"
  end
  
  post '/pulse' do
    rows = ActiveRecord::Base.connection.execute("select 1 from dual").num_rows rescue 0
    rows == 1 ? "OK" : "Error!"
  end
  
  get '/pulse/error' do
    raise 'Hoptoad test'
  end
end