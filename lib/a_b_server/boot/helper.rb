Application.class_eval do

  Dir["#{root}/lib/a_b_server/helper/*.rb"].sort.each do |path|
    require path
  end
end