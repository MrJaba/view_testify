class ViewParser
  attr_reader :mocks, :template_stubs, :routes
  
  def self.parse( template_path, options={} )
    ViewParser.new( template_path, options )
  end
  
  def initialize( template_path, options={} )
    @template_path = template_path
    @application = RailsApplication.new( options )
    parse_template
  end
  
  def name
    controller_name+"_"+view_name
  end
  
  def view_name
    template_stem.split("/").last
  end
  
  def controller_name
    template_stem.split("/").first
  end
  
  def template_stem    
    @template_path =~ /app\/views\/(.*?)\.html\.erb/
    return $1
  end
  
  def is_partial?
    @template_path =~ /\/_|\_/
  end
  
  def root_directory
    root_directory = ''
    root_depth = @template_path.split('/').size - 2
    root_depth.times do
      root_directory += '/..'
    end
    root_directory
  end
  
  #Not sure this object should know about the test directory.. refactor out?
  def path_to_test_file
    "test/views/test_#{template_stem}.rb"
  end
  
private

  def parse_template
    @mocks, @template_stubs, @routes = [], [], []
    IO.readlines( @template_path ).each do | line |
      @mocks += instance_vars( line )
      @template_stubs += helper_method_names( line )
      @routes += named_routes( line )
    end
    @mocks.uniq!
    @template_stubs.uniq!
    @routes.uniq!
  end
  
  def instance_vars( template_line )
    mocks = []
    template_line.scan(/@(.+?)\b/).flatten.each do | variable_name |
      begin
        variable_name.classify.constantize
        mocks << variable_name
      rescue NameError
        mocks << variable_name
      end
    end
    mocks
  end
   
  def helper_method_names( template_line )
    stubs = []
    @application.helper_methods.each do | helper_method |
      stubs << helper_method if template_line[ helper_method ]
    end   
    stubs
  end
  
  def named_routes( template_line )
    stubs = []
    @application.routes.each do | route|
      stubs << route if template_line[ route ]
    end
    stubs
  end
  
end