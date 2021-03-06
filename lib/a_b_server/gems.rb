unless defined?(ABServer::Gems)
  
  require 'rubygems'
  
  module ABServer
    class Gems
    
      VERSIONS = {
        :active_wrapper => '=0.3.4',
        :cucumber => '=0.9.4',
        :haml => '=3.0.24',
        :json => '=1.4.6',
        :lilypad => '=0.3.1',
        :newrelic_rpm => '=2.13.3',
        :'rack-test' => '=0.5.6',
        :rake => '=0.8.7',
        :rspec => '=1.3.1',
        :sinatra => '=1.1.0',
        :whenever => '=0.6.2',
        :with_pid => '=0.1.5'
      }
    
      TYPES = {
        :console => [ :active_wrapper, :sinatra ],
        :dj => [ :with_pid ],
        :gemspec => [ :active_wrapper, :haml, :json, :lilypad, :newrelic_rpm, :sinatra, :whenever, :with_pid ],
        :gemspec_dev => [ :cucumber, :rspec, :'rack-test' ],
        :lib => [ :active_wrapper, :haml, :json, :lilypad, :newrelic_rpm, :sinatra ],
        :rake => [ :active_wrapper, :rake, :rspec ],
        :spec => [ :'rack-test', :rspec ]
      }
      
      class <<self
        
        def lockfile
          file = File.expand_path('../../../gems', __FILE__)
          unless File.exists?(file)
            File.open(file, 'w') do |f|
              Gem.loaded_specs.each do |key, value|
                f.puts "#{key} #{value.version.version}"
              end
            end
          end
        end
        
        def require(type=nil)
          (TYPES[type] || TYPES.values.flatten.compact).each do |name|
            gem name.to_s, VERSIONS[name]
          end
        end
      end
    end
  end
end