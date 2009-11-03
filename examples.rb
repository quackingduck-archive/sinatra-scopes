require 'exemplor'

require 'app'
set :environment, :test
require 'rack/test'

eg.helpers do
  include Rack::Test::Methods
  def app; Sinatra::Application end
end

eg "Requesting an action built from a scope" do
  get('/projects/a/edit').body
end

