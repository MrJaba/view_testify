require File.dirname(__FILE__) + "<%= parsed_view.root_directory %>/test_helper"
require File.dirname(__FILE__) + "/../mock_model"
require File.dirname(__FILE__) + "/../view_isolation"

class <%= parsed_view.name.classify%>Test < ActionController::TestCase
  tests <%=parsed_view.controller_name.classify.pluralize%>Controller
  
  def setup
    @controller = <%=parsed_view.controller_name.classify.pluralize%>Controller.new
    <%- parsed_view.mocks.each do | mocked_variable_name | %>
    @controller.instance_variable_set( "@<%=mocked_variable_name%>", MockModel.new )
    <%- end %>
    <%- parsed_view.template_stubs.each do | helper_stub | %>
    def @controller.<%= helper_stub %>; return MockModel.new; end
    <%- end %>
    <%- parsed_view.routes.each do | route_stub | %>
    def @controller.<%= route_stub %>; return ''; end 
    <%- end %>    
  end
  
  def test_render
    render :template => "<%= parsed_view.template_stem %>"
  end
  
end

