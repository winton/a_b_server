Application.class_eval do
  
  get '/pulse' do
    rows = ActiveRecord::Base.connection.execute("select 1 from dual").num_rows rescue 0
    rows == 1 ? "OK" : "Error!"
  end
end