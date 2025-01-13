require_relative 'main.rb'
startup()

get ('/') do
  html('index.html')
end

get ('/test') do
  html('test.html')
end

get ('/test2') do
  slim('test2.slim')
end
