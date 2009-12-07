require 'sinatra'
require 'lib/sinatra/scopes'

Project = {'a' => 'Project A', 'b' => 'Project B'}
User = {'1' => 'User 1', '2' => 'User 2'}

scope :project, '/projects/*' do |project_id|
  @project = Project[project_id]
end

project.get '/users/*' do |user_id|
  @user = User[user_id]
  "#{@project}, #{@user}"
end

helpers do
  def auth; true end
end

scope(:authorized) { auth }

authorized.get '/sekret/*' do |page|
  page
end