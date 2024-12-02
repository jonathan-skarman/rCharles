# frozen_string_literal: true

require 'socket'
require_relative 'request'

# router klass så för läsbarhet
class Router
	def initialize
		@routes = { '/teapot' => './public/teapot.html' }
	end

	def add_route(resource)
		if route_exist?(resource)
			@routes[resource]
		elsif resource.nil? || !File.exist?("./public#{fix_index(resource)}.html")
			nil
		else
			@routes[resource] = "./public#{fix_index(resource)}.html"
			@routes[resource]
		end
	end

	def route(resource)
		@routes[resource]
	end

	private

	def route_exist?(resource)
		@routes.key?(resource)
	end

	def fix_index(resource)
		resource = '/index' if resource == '/'
		resource
	end
end

# sluta klaga rubocop
class HTTPServer
	def initialize(port)
		@port = port
	end

	def start
		server = TCPServer.new(@port)
		puts "Listening on #{@port}"
		router = Router.new

		while @session = server.accept # rubocop:disable Lint/AssignmentInCondition
			data = ''
			while line = @session.gets and line !~ /^\s*$/ # rubocop:disable Lint/AssignmentInCondition,Style/AndOr
				data += line
			end

			terminal_print(data)

			request = Request.new(data)
			router.add_route(request.resource) # if don't have route, add route

			Response.new.send(router.route(request.resource), @session)
		end
	end

	# Nedanstående bör göras i er Response-klass # rubocop:disable Layout/CommentIndentation
		#lättare med annan metod i httpserver, annars måste jag lista ut hur jag flyttar session # rubocop:disable Layout/CommentIndentation,Layout/LeadingCommentSpace

	def terminal_print(data)
		puts 'RECEIVED REQUEST'
		puts '-' * 40
		puts data
		puts '-' * 40
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
		if route == './public/teapot.html'
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
