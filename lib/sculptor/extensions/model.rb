class Middleman::Extensions::Model < ::Middleman::Extension
  def initialize(app, options_hash={})
    super

    require 'open-uri'
    require 'nokogiri'
  end

  helpers do
    # Requires either `&block` or `location`
    # `location` - string with remote location to fetch the HTML from.
    # Options:
    # * `title` (optional) - Model title
    # * `description` (optional) - Model description
    # * `css` (optional, defaults to `body`) - element(s) with CSS selector
    #       to extract from the page. If a particular element is required it can
    #       be requested by providing 0-based index of the list of matches.
    #       e.g. `img #0`
    # * `&block` (optional)
    def model(*options, &block)
      location = options.first.is_a?(String) && options.shift || nil
      options = options.first || {}
      if block_given?
        html = capture_html(&block)
        metadata = options
      elsif location
        # Remote location
        if location.start_with?('http')
          result = grab_remote(location, options[:css], options)
          metadata = options
          html = result.to_html
        # Assume local path
        else
          resource = sitemap.find_resource_by_path(relative_dir(current_page.path, location).to_s)
          raise "Included model at `#{location}` was not found" unless resource
          metadata = resource.metadata.page

          # Hack: inject local data that can be provided as parameter
          # Provided under `data.page` in partials (.component)
          resource.add_metadata({ page: options[:data] || {} })

          html = resource.render(layout: false)
        end
      else
        raise "Model `#{options[:title]}`: `url` or HTML block is missing"
      end

      options.reverse_merge!(metadata.symbolize_keys!)

      options[:title] = options[:title] || data.page.title
      options[:description] = options[:description] || data.page.description

      current_page.add_metadata({ page: { iframe: options[:iframe] || false }})

      options[:html] = html
      options[:source_code] = html
      options[:source_type] ||= 'html'

      partial('partials/glyptotheque/model', locals: options)
    end

    def model_iframe(location=nil, options={}, &block)
      options[:iframe] = true
      model(location, options, &block)
    end

    def model_source(type, &block)
      source_code = capture_html(&block)
      partial('partials/glyptotheque/model-source', locals: { source_type: type, source_code: source_code })
    end

    private

    def grab_remote(url, css, options)
      puts "Fetching from #{url}"

      css ||= 'body'

      selector_index_pair = css.split(/\s+#(\d+)$/)

      if options[:pretty] == true
        doc = Nokogiri::XML(open(url), &:noblanks)
      else
        doc = Nokogiri::HTML(open(url), &:noblanks)
      end

      result = doc.css(selector_index_pair[0])
      puts "Matching CSS: `#{selector_index_pair[0]}` (found #{pluralize(result.count, 'element')})"

      # Select element with specified index e.g. `.selector #1`
      if selector_index_pair[1]
        puts "Select index #{selector_index_pair[1].to_i} from the list"
        result = result[selector_index_pair[1].to_i]
      end

      @root_url = "#{URI(url).scheme}://#{URI(url).host}/"

      if result.class == Nokogiri::XML::NodeSet
        result.css('[src]').map do |e|
          e.set_attribute('src', parse_relative_url(url, e.attr('src')))
        end
      elsif result.class == Nokogiri::XML::Element
        result.set_attribute('src', parse_relative_url(url, result.attr('src'))) if result.attr('src')
      end

      if !result || result.is_a?(Array) && result.empty?
        raise "Selector `#{selector_index_pair[0]}`#{selector_index_pair[1] ? '(index: ' + selector_index_pair[1] + ')': ''} not found at remote location`#{url}`"
      end

      return result
    end

    def parse_relative_url(url, path)
      is_root = path.match(/^\/[^\/].*/)
      if is_root
        path.sub(/^\/(.*)/, @root_url + $1)
      elsif path.match(/^\.{1,2}\//)
        relative_dir(url, path).to_s
      elsif path.match(/^\/\//)
        "#{URI(url).scheme}:#{path}"
      else
        path
      end
    end
  end
end
