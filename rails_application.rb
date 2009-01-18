require 'rake'

class RailsApplication
  
  def initialize( options )
    @options = options
  end
  
  def helper_methods
    helper_files = FileList["app/helpers/*.rb"]
    helper_files += FileList["vendor/plugins/**/*_helper.rb"]
    @helper_methods ||= helper_files.collect do | helper_file |
      IO.readlines( helper_file ).join.scan( /def\s+(.+)[(\b]/ )
    end.flatten + extra_stubs
    @helper_methods
  end

  def routes
    unless @routes
      @routes = []
      ActionController::Routing::Routes.routes.collect do |route|
        stem = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
        next if stem.blank?
        @routes << "#{stem}_path"
        @routes << "#{stem}_url"
      end
    end
    return @routes
  end
  
private

  def extra_stubs
    @options[:stubs].blank? ? [] : @options[:stubs]
  end   
   
end