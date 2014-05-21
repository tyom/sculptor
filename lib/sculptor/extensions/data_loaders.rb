class Middleman::Extensions::DataLoaders < ::Middleman::Extension
  def initialize(app, options_hash={})
    super

    require 'open-uri'
  end

  helpers do
    def pwd
      File.dirname(File.expand_path(current_page.path, root))
    end

    def load_data(path, options = nil)
      resource = if path.start_with? 'http'
        load_remote_data(path, options)
      else
        sitemap.find_resource_by_path(relative_dir(current_page.path, path).to_s)
      end

      raise "#{path} not found" unless resource

      if ['.yaml', '.yml'].include? resource.ext
        yaml = resource.render
      elsif resource.ext == '.json'
        json = resource.render
      end

      if json
        JSON.parse(resource.render)
      elsif yaml
        YAML.load(resource.render)
      end
    end

    private

    def load_remote_data(url, options)
      begin
        if(options)
          resource = open(url, http_basic_authentication: [options[:user], options[:password]])
        else
          resource = open(url)
        end
      rescue
        raise "Couldn't load the remote: #{url}."
      end
      {
        ext: '.json',
        render: resource.read
      }
    end
  end
end
