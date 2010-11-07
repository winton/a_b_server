namespace :cron do
  
  desc 'Every day cron job'
  task :every_day => :environment do
    $db.establish_connection
    sql = <<-SQL
      DELETE
      FROM requests
      WHERE updated_at < '#{1.day.ago.utc.to_s(:sql)}'
    SQL
    puts "#{$db.delete(sql)} requests destroyed"
  end
end