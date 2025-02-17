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

  startup(router, server)
end

App.run
