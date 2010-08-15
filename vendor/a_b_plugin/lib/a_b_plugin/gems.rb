unless defined?(ABPlugin::Gems)
  
  require 'rubygems'
  
  class ABPlugin
    class Gems
    
      VERSIONS = {
        :httparty => '=0.5.2',
        :json => '=1.2.0',
        :'rack-test' => '=0.5.3',
        :rake => '=0.8.7',
        :rails => '=2.3.5',
        :rspec => '=1.3.0',
        :sinatra => '=1.0'
      }
    
      TYPES = {
        :gemspec => [ :httparty ],
        :gemspec_dev => [ :json, :'rack-test', :rails, :rspec, :sinatra ],
        :lib => [ :httparty ],
        :rake => [ :rake, :rspec ],
        :spec => [ :json, :'rack-test', :rails, :rspec, :sinatra ]
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