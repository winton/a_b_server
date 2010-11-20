$:.unshift File.expand_path('../../../../vendor/delayed_job/lib', __FILE__)
require 'delayed_job'

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 10
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 10.minutes