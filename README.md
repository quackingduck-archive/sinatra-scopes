Sinatra Scopes
==============

Simple scoping for your request handlers. From `example_app.rb`:

    scope :project, '/projects/*' do |project_id|
      @project = Project[project_id]
    end

    project.get '/users/*' do |user_id|
      @user = User[user_id]
      "#{@project}, #{@user}"
    end

Scopes don't have to specify a path pattern:

    scope(:authorized) { auth }

    authorized.get '/sekret/*' do |page|
      page
    end