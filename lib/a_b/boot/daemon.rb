require 'daemons'
require 'optparse'

class ABDaemon
  
  def initialize(args)
    @files_to_reopen = []
    @worker_count = 1
    
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename($0)} [options] start|stop|restart|run"
      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit 1
      end
      opts.on('-n', '--number=workers', "Number of unique workers to spawn") do |worker_count|
        @worker_count = worker_count.to_i rescue 1
      end
    end
    
    @args = opts.parse!(args)
  end

  def daemonize
    ObjectSpace.each_object(File) do |file|
      @files_to_reopen.push(file) if file.path.include?('.log')
    end
    
    worker_count.times do |worker_index|
      name = worker_count == 1 ? "a_b_daemon" : "a_b_daemon.#{worker_index}"
      options = {
        :ARGV => @args,
        :dir => "#{Application.root}/tmp/pids",
        :dir_mode => :normal
      }
      Daemons.run_proc(name, options) { |*args| run name }
    end
  end
  
  def run(name = nil)
    Dir.chdir(Application.root)
    ActiveRecord::Base.connection.reconnect!
    
    # Re-open file handles
    @files_to_reopen.each do |file|
      begin
        file.reopen File.join(Application.root, 'log', 'daemon.log'), 'a+'
        file.sync = true
      rescue ::Exception
      end
    end
    
    ABRequest.say "Starting #{name}"

    trap('TERM') { $log.info 'Exiting...'; $exit = true }
    trap('INT')  { $log.info 'Exiting...'; $exit = true }
    
    loop do
      realtime = Benchmark.realtime { ABRequest.process! }
      ABRequest.say("Finished #{name} in %.4f s" % [ realtime ])
      break if $exit
    end

  rescue => e
    ABRequest.say [ e.message, e.backtrace ].join("\n")
    STDERR.puts e.message
    exit 1
  end
end