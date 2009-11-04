module Sinatra
  
  class Scope

    def initialize(app, pattern, &blk)
      @app = app
      @pattern = pattern || ''
      @block = blk
    end

    attr_reader :pattern, :block

    def create_action(http_method, pattern, &blk)
      scope = self
      @app.send(http_method, scope.pattern + pattern) do |*args|
        # run the scope block
        self.instance_exec(*args[0...scope.block.arity], &scope.block)
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
  
  module ScopeBuilder
    
    def scope(name, pattern = nil, &blk)
      @scopes ||= {}
      @scopes[name] = Scope.new Sinatra::Application, pattern, &blk
    end
    
    # hacky? I can't figure out which object to #define_method on
    def method_missing(name)
      return super unless @scopes.has_key? name
      @scopes[name]
    end
    
  end

  register ScopeBuilder
end