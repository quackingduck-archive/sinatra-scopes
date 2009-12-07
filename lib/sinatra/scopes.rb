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
    
    def scopes
      @scopes ||= {}
    end
    
    def scope(name, pattern = nil, &blk)
      scopes[name] = Scope.new self, pattern, &blk
      mod = Module.new
      mod.module_eval %{def #{name}; scopes[:#{name}] end}
      register mod
    end
    
  end

  register ScopeBuilder
end