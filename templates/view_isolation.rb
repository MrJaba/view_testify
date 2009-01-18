#Courtesy of http://broadcast.oreilly.com/2008/10/testing-rails-partials.html
class ApplicationController
  def _renderizer; render params[:args]; end
end

class ActionController::TestCase # or Test::Unit::TestCase, for Rails <2.0
  def render( args ); get :_renderizer, :args => args; end
end