require 'rake'
require 'rbconfig'
require File.dirname(__FILE__)+"/view_parser"
require File.dirname(__FILE__)+"/rails_application"

class ViewTestifyGenerator < Rails::Generator::Base
  
  def manifest
    record do | generate |
      view_files = FileList["app/views/**/*.html.erb"]      
      view_files.each do | view_template_path |
        parsed_view = ViewParser.parse( view_template_path, options )
        next if parsed_view.is_partial?                
        generate.directory( File.dirname( parsed_view.path_to_test_file ) )
        generate.template 'view_test.rb', parsed_view.path_to_test_file, :assigns => { :parsed_view => parsed_view }
      end
      generate.template 'mock_model.rb', 'test/views/mock_model.rb'
      generate.template 'view_isolation.rb', 'test/views/view_isolation.rb'
    end
  end
  
protected
  
  def banner
    "Usage: #{$0} [options]"
  end

  def add_options!( opt )
    opt.separator ''
    opt.separator 'Options:'
    opt.on("", "--stubs=stub1,stub2,stub3", String, "Extra template stubs to add, comma-delimited", "Default: none") { |v| options[:stubs] = v.split(',') }
  end
  
end