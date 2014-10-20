class Middleman::Extensions::ResourceHelpers < ::Middleman::Extension
  def initialize(app, options_hash={})
    super
    require 'rest_client'
  end

  helpers do
    def include_javascripts(javascripts)
      include_assets(:javascript_include_tag, javascripts)
    end

    def include_stylesheets(stylesheets)
      include_assets(:stylesheet_link_tag, stylesheets)
    end

    def resource_file(resource)
      resource.path.split('/').last.gsub(resource.ext, '')
    end

    def resource_dir(resource)
      resource.url.split('/').last
    end

    def resources_for(dir, ext: 'html', exclude_indexes: false, sort_by: nil)
      resources = sitemap.resources
        .select  {|r| r.ext == ".#{ext}"}                # Select files only HTML files
        .reject  {|r| r.data.hidden}                     # reject hidden (Front matter)
        .select  {|r| r.url.start_with?(dir)}            # Select files in the given dir
        .sort_by {|r| r.url }                            # Sort by url (default)
        .sort_by {|r| r.data[sort_by] || -1}             # Sort by `sort_by` param
        .reject  {|r| r.url == dir}                      # Exclude main directory index
        .reject  {|r|                                    # Exclude all directory indexes
          exclude_indexes ? r.directory_index? : false
        }

      resources.reject {|r| r.path.end_with? ("-standalone#{r.ext}")} # Ignore proxied '-standalone' mode pages
    end

    def local_data(path)
      result = sitemap.find_resource_by_path(relative_dir(current_page.path, path).to_s)
      raise "#{path} not found" unless result

      case result.ext
      when '.yaml', '.yml'
        result = YAML.load(result.render)
      when '.json'
        result = Oj.load(result.render)
      end

      result
    end

    # Use in layouts, in templates either Frontmatter or this method can be used
    def append_class(block_name, appended_classes='')
      current_page_classes = current_page.data[block_name] || ''
      existing_classes_a = current_page_classes.split(' ')
      appended_classes_a = appended_classes.split(' ')
      classes = existing_classes_a.concat(appended_classes_a).reverse.join(' ')
      content_for(block_name, classes)
    end

    def get(url, options = {})
      begin
        result = RestClient.get(url, options)
      rescue => e
        raise "GET - #{e.message}: '#{url}'"
      end

      Oj.load(result)
    end

    def post(url, params = {}, headers = {})
      begin
        result = RestClient.post(url, params, headers)
      rescue => e
        raise "POST - #{e.message}: '#{url}'"
      end

      Oj.load(result)
    end

    private

    def include_assets(asset_tag, assets)
      return unless assets
      assets = assets.split(/,\s*/) if assets.is_a? String
      Array(assets).map { |a|
        path = a.start_with?('http') ? a : relative_dir(current_page.path, a)
        "\n" + method(asset_tag).call(path)
      }.join
    end

    # Constructs path relative to base path (first argument)
    def relative_dir(path, *args)
      relative_path = args ? args.join('/') : ''
      Pathname(path).dirname.join(relative_path)
    end
  end
end
