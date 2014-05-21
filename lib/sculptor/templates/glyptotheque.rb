# Sculptor Glyptotheque template
class Middleman::Templates::Glyptotheque < Middleman::Templates::Base
  class_option :css_dir, default: 'assets/styles'
  class_option :js_dir, default: 'assets/js'
  class_option :images_dir, default: 'assets/img'

  # Template files are relative to this file
  # @return [String]
  def self.source_root
    File.dirname(__FILE__)
  end

  def self.gemfile_template
    'glyptotheque/Gemfile.tt'
  end

  def generate_gitignore!
  end

  # Output the files
  # @return [void]
  def build_scaffold!
    template 'glyptotheque/config.tt', File.join(location, 'config.rb')
    copy_file 'glyptotheque/.bowerrc', File.join(location, '.bowerrc')
    copy_file 'glyptotheque/.gitignore', File.join(location, '.gitignore')
    copy_file 'glyptotheque/.editorconfig', File.join(location, '.editorconfig')
    copy_file 'glyptotheque/bower.json', File.join(location, 'bower.json')
    directory 'glyptotheque/source', File.join(location, 'source')
    directory 'glyptotheque/data', File.join(location, 'data')
  end
end

# Register the template
Middleman::Templates.register(:glyptotheque, Middleman::Templates::Glyptotheque)
