class ABPlugin
  class Yaml
    
    attr_reader :path
    attr_reader :yaml
    
    def initialize(path)
      if path && File.exists?(path)
        @path = path
        @yaml = YAML::load(File.open(@path))
        if @yaml && Config.env && @yaml[Config.env]
          @yaml = @yaml[Config.env]
        end
      end
    end
    
    def configure_api
      if @yaml
        ABPlugin::Config.url @yaml['url']
        ABPlugin::Config.token @yaml['token']
      end
    end
    
    def dirname
      if @path
        File.dirname(@path)
      end
    end
    
    def method_missing(method, *args)
      if @yaml
        @yaml.send method, *args
      else
        nil
      end
    end
  end
end