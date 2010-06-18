class ABPlugin
  class Yaml
    
    attr_reader :data
    attr_reader :path
    
    def initialize(path)
      if path && File.exists?(path)
        @path = path
        @data = YAML::load(File.open(@path))
      end
    end
    
    def configure_api
      if @data
        ABPlugin::Config.site @data['site']
        ABPlugin::Config.token @data['token']
        ABPlugin::Config.url @data['url']
      end
    end
    
    def dirname
      File.dirname(@path) if @path
    end
    
    def method_missing(method, *args)
      @data ? @data.send(method, *args) : nil
    end
  end
end