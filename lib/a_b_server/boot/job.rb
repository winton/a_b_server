Application.class_eval do

  Dir["#{root}/lib/a_b_server/job/*.rb"].sort.each do |path|
    require path
  end
  Delayed::Worker.guess_backend
end