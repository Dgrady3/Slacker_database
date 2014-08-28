require 'sinatra'
require 'pry'
require 'sinatra/reloader'
require 'pg'


def db_connection
  begin
    connection = PG.connect(dbname: 'joegrady')

    yield(connection)
  ensure
    connection.close
  end
end


#####################################
              # ROUTES
#####################################


get '/' do
  query = 'SELECT url, title, description FROM articles;'
  db_connection do |conn|
    @articles = conn.exec(query).to_a
    erb :index
  end
end



get '/submit' do
  erb :submit
end


post '/submit' do
  article = []
  article << params["article_url"]
  article << params["article_title"]
  article << params["article_description"]
  query = "INSERT INTO articles (url, title, description) VALUES ($1, $2, $3)"
  stuff = article
  db_connection do |conn|
    conn.exec_params(query, article)
  end

redirect '/'
end




# get '/' do
#   @tasks = File.readlines('public/tasks.csv')
#   erb :index
# end

# post '/tasks' do
#   binding.pry
#   # Read the input from the form the user filled out
#   task = params['task_name']

#   # Open the "tasks" file and append the task
#   File.open('tasks', 'a') do |file|
#     file.puts(task)
#   end

#   # Send the user back to the home page which shows
#   # the list of tasks
#   redirect '/'
# end
