Application.class_eval do
  
  $db, $log, $mail = ActiveWrapper.setup(
    :base => root,
    :env => environment,
    :stdout => $0 != 'script/daemon' && $0 != 'irb' && $0[-5..-1] != '/rake' && environment != :test
  )
  
  $db.establish_connection

  ActionMailer::Base.raise_delivery_errors = true
end