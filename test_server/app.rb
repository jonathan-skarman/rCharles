require_relative '../lib/main.rb'
startup()

get ('/') do
  html('index')
end

get ('/index') do
  html('index')
end

get ('/test') do
  html('test')
end

get ('/test2') do
  slim('test2')
end
