class Middleman::Extensions::ResourceHelpers < ::Middleman::Extension
  helpers do
    def include_stylesheets(stylesheets)
      return unless stylesheets && stylesheets.is_a?(Array) && stylesheets.length > 0
      stylesheets.map { |s|
        include_stylesheet(s)
      }.join("\n")
    end

    def include_stylesheet(stylesheet)
      return if stylesheet.empty?
      stylesheet_link_tag(relative_dir(current_page.path, stylesheet)) + "\n"
    end

    def include_javascripts(javascripts)
      return unless javascripts && javascripts.is_a?(Array) && javascripts.length > 0
      javascripts.map { |j|
        path = j.start_with?('http') ? j : relative_dir(current_page.path, j)
        javascript_include_tag(path) + "\n"
      }.join("\n")
    end

    # Constructs path relative to base path (first argument)
    def relative_dir(path, *args)
      relative_path = args ? args.join('/') : ''
      Pathname(path).dirname.join(relative_path)
    end

    def resource_file(resource)
      resource.path.split('/').last.gsub(resource.ext, '')
    end

    def resource_dir(resource)
      resource.url.split('/').last
    end

    def subpages_for(dir, ext = 'html', exclude_indexes: false)
      resources = sitemap.resources
        .select {|r| r.ext == ".#{ext}"}                # Select files only HTML files
        .reject {|r| r.data.hidden}                     # reject hidden (Front matter)
        .select {|r| r.url.start_with?(dir)}            # Select files in the given dir
        .sort_by(&:url)                                 # Sort by URL (ensures indexes first)
        .reject {|r| r.url == dir}                      # Exclude main directory index

      if exclude_indexes
        resources = resources.reject {|r| r.directory_index? } # Exclude all directory indexes
      end

      resources.reject {|r| r.path.end_with? ("-full#{r.ext}")} # Ignore proxied '-full' mode pages
    end

    # Use in layouts, in templates either Frontmatter or this method can be used
    def append_class(block_name, appended_classes='')
      current_page_classes = current_page.data[block_name] || ''
      existing_classes_a = current_page_classes.split(' ')
      appended_classes_a = appended_classes.split(' ')
      classes = existing_classes_a.concat(appended_classes_a).reverse.join(' ')
      content_for(block_name, classes)
    end
  end
end
