class Middleman::Extensions::Model < ::Middleman::Extension
  def initialize(app, options_hash={})
    super

    require 'open-uri'
    require 'nokogiri'
  end

  helpers do
    # Requires one of `&block` or `url + selector`
    # Parameters:
    # * `title` (optional) - Model title
    # * `description` (optional) - Model description
    # * `component_url` (optional) - Model URL
    # * `component_selector` (required if `url` is provided)
    # * `&block` (optional)
    def model(options={}, &block)
      [:title, :description].each { |k| options[k] ||= nil }

      if block_given?
        html = capture_html(&block)
        metadata = options
      elsif options[:component]
        component_path = "components/#{options[:component]}"
        resource = sitemap.find_resource_by_path("#{component_path}.html")
        metadata = resource.metadata.page
        html = resource.render

      # TODO: Refactor
      elsif options[:component_url] && options[:component_selector]
        metadata = options
        if options[:pretty] == true
          doc = Nokogiri::XML(open(options[:component_url]), &:noblanks)
        else
          doc = Nokogiri::HTML(open(options[:component_url]), &:noblanks)
        end

        index_regex = /\s+#(\d+)$/
        component_selector = options[:component_selector].sub(index_regex, '')
        component_index = options[:component_selector].match(index_regex)

        result = doc.css(component_selector)

        # Select element with specified index e.g. `.selector #1`
        if component_index
          result = result[component_index[1].to_i]
        end

        if !result || result.is_a?(Array) && result.empty?
          raise "Selector `#{component_selector}`#{component_index ? '(index: ' + component_index[1] + ')': ''} not found at remote location`#{options[:component_url]}`"
        end

        html = result.to_xml
      else
        raise "Model `#{options[:title]}`: No `component` of HTML block was given"
      end

      options.reverse_merge!(metadata.symbolize_keys!)
      options[:html] = html

      options[:source_code] = html unless options.has_key? :source_code
      options[:source_type] ||= 'html'

      partial('partials/glyptotheque/model', locals: options)
    end

    def model_source(type, &block)
      source_code = capture_html(&block)
      partial('partials/glyptotheque/model-source', locals: { source_type: type, source_code: source_code })
    end
  end
end
