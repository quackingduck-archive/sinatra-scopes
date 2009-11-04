require 'exemplor'

require 'app'
set :environment, :test
require 'rack/test'

eg.helpers do
  include Rack::Test::Methods
  def app; Sinatra::Application end
end

eg "Requesting an action built from a scope" do
  Check(get('/projects/a/users/2').body).is('Project A, User 2')
  Check(get('/projects/b/users/1').body).is('Project B, User 1')
end

