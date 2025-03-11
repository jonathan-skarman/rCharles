require_relative '../lib/main.rb'


class App
  router = Router.new
  server = HTTPServer.new(4567, router)

  router.get('/') do
    server.html('index')
  end

  router.get('/index') do
    server.html('index')
  end

  router.get('/test') do
    server.html('test')
  end

  router.get('/test2') do
    server.slim('test2')
  end

  router.get('/testmapp/:id/testsida/:id2') do |params|
    server.slim('testmapp/testsida', params)
  end

  server.start
end

App.run
