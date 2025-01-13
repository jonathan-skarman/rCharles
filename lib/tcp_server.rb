# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'router'
require_relative ''

# sluta klaga rubocop
class HTTPServer
	def initialize(port)
		@port = port
	end

	def start
		server = TCPServer.new(@port)
		puts "Listening on #{@port}"
		router = Router.new # give the app.rb file to the router

		while @session = server.accept # rubocop:disable Lint/AssignmentInCondition
			data = parse_data(@session)

			terminal_print(data)

			request = Request.new(data)
			router.add_route(request.resource) # if don't have route, add route

			Response.new.send(router.route(request.resource), @session)
		end
	end

	private

	def terminal_print(data)
		puts 'RECEIVED REQUEST'
		puts '-' * 40
		puts data
		puts '-' * 40
	end

	def parse_data(session)
		data = ''
		while line = session.gets and line !~ /^\s*$/ # rubocop:disable Lint/AssignmentInCondition,Style/AndOr
			data += line
		end

		if data.nil?
			Response.new.session_response('400', '<h1>400 bad request</h1>', @session)
			raise 'ingen data i request'
		end

		data
	end
end

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize; end # rubocop:disable Style/RedundantInitialize

	def send(route, session)
		html, status = html_status(route)
		session_response(status, html, session)
	end

	private

	def html_status(route)
		if route == './test_server/public/teapot.html'
			html = '<h1>418 I am a teapot</h1>'
			status = '418'
		elsif route.nil?
			html = '<h1>404 Not Found</h1>'
			status = '404'
		else
			html = File.read(route)
			status = '200'
		end
		[html, status]
	end

	def session_response(status, html, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: text/html\r\n"
		session.print "\r\n"
		session.print html
		session.close
	end
end

# html = "<h1>404 Not Found</h1>"
# status = '404'
