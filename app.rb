require 'sinatra'

class Scope
  
  def initialize(app, pattern = nil, &blk)
    @app = app
    @pattern = pattern || ''
    @block = blk
  end
  
  attr_reader :pattern, :block
  
  def create_action(http_method, pattern, &blk)
    scope = self
    @app.send(http_method, scope.pattern + pattern) do |*args|
      # run the scope block
      self.instance_exec(*args[0..scope.block.arity], &scope.block)
      # run the action block
      self.instance_exec(*args[scope.block.arity..-1], &blk)
    end
  end
  
  def get(pattern, &blk)
    create_action :get, pattern, &blk
  end
  
  def post(pattern, &blk)
    create_action :post, pattern, &blk
  end
  
end

def scope(pattern = nil, &blk)
  Scope.new Sinatra::Application, pattern, &blk
end

module Sinatra
  
  module ScopeBuilder
    
    def scope(name, pattern = nil, &blk)
      Scope.new Sinatra::Application, pattern, &blk
    end
    
    
    
  end

  register ScopeBuilder
end

Projects = {
  'a' => "Project A", 'b' => "Project B"
}

# TODO: change api to scope(:project, 'pattern', &blk)
project = scope '/projects/*' do |project_code|
  @project = Projects[project_code]
end

project.get '/edit' do
  "Editing: #{@project}"
end