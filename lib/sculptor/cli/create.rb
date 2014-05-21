module Sculptor::CLI
  class Create < Thor
    include Thor::Actions

    check_unknown_options!

    namespace :create

    def self.source_root
      File.join(File.dirname(__FILE__), '..', 'templates', 'model')
    end

    def self.exit_on_failure?
      true
    end

    desc 'create NAME', 'Create new model NAME'
    def create(name)
      model_path = "source/#{name}"

      say(set_color("Creating model: ", :yellow) + set_color(model_path, :white, :bold))

      is_subdir = name.split('/').count > 1
      parent_path = is_subdir ? model_path.split('/')[0..-2].join('/') : model_path

      @name = name
      @title = options[:title] || ask('Title: ')
      @description = options[:desc] || ask('Description: ')
      @stylesheet = ask('Stylesheet: ')
      @dir = is_subdir ? name.split('/')[0..-2].join('/') : name

      @has_data = if yes?('Include data?')
        @model_name = name.split('/').last
        template 'data', (is_subdir ? model_path : File.join(model_path, name)) + '.yaml'
      end

      template 'template', (is_subdir ? model_path : File.join(model_path, name)) + '.html.slim'

      has_index = File.file?(File.join(parent_path, 'index.html.slim'))
      unless has_index
        template 'index-template', (is_subdir ? File.join(parent_path, 'index') : File.join(model_path, 'index')) + '.html.slim'
      end

      unless @stylesheet.empty?
        stylesheet_path = is_subdir ? Pathname(model_path).join("../#{@stylesheet}").to_s : File.join(model_path, "#{@stylesheet}")
        template 'styles', "#{stylesheet_path}.scss" unless File.file? "#{stylesheet_path}.scss"
      end
    end

    Base.map(
      'c'      => 'create'
    )
  end
end
