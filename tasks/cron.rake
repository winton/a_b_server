namespace :cron do
  
  desc 'Every day cron job'
  task :every_day => :environment do
    $db.establish_connection
    
    sql = <<-SQL
      DELETE
      FROM requests
      WHERE updated_at < #{$db.quote 1.day.ago.utc}
    SQL
    puts "#{$db.delete(sql)} requests destroyed"
    
    sql = <<-SQL
      DELETE
      FROM ips
      WHERE `date` < #{$db.quote 1.day.ago.utc}
    SQL
    puts "#{$db.delete(sql)} ips destroyed"
  end
end