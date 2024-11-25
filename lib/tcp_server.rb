# frozen_string_literal: true
require 'socket'
require_relative 'request'

# router klass eftersom den tydligen behövs
class Router
	def initialize
		@routes = {}
	end

	def fix_index(resource)
		if resource == "/"
			resource = "/index"
		end
		resource
	end

	def add_route(resource)
		if !file_exist?(fix_index(resource))
			raise "file doesn't exist (this is raise)"
		elsif route_exist?(resource)
			raise "route already exists (this is raise)"
		else
			@routes[resource] = "./public#{fix_index(resource)}.html"
		end
	end

	def route(resource)
		@routes[resource]
	end

	def route_exist?(resource)
		if @routes[resource]
			return true
		else
			return false
		end
	end

	def file_exist?(resource)
		File.exist?("./public#{resource}.html")
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
			while line = @session.gets and line !~ /^\s*$/ # rubocop:disable Lint/AssignmentInCondition
				data += line
			end

			terminal_print(data)

			request = Request.new(data)
			if !router.route_exist?(request.resource) #if dont have route, add route
				router.add_route(request.resource)
			end

			html, status = Response.new.send(router.route(request.resource))

			session_response(status, html)
		end
	end

	# Nedanstående bör göras i er Response-klass
		#lättare med annan metod i httpserver, annars måste jag lista ut hur jag flyttar session
	def session_response(status, html)
		@session.print "HTTP/1.1 #{status}\r\n"
		@session.print "Content-Type: text/html\r\n"
		@session.print "\r\n"
		@session.print html
		@session.close
	end

	def terminal_print(data)
		puts 'RECEIVED REQUEST'
		puts '-' * 40
		puts data
		puts '-' * 40
	end
end

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize
	end

	def html_status(route)
		html = File.read(route)
		status = '200'
		return html, status
	end

	def send(route)
		html, status = html_status(route)
		return html, status
	end
end


#html = "<h1>404 Not Found</h1>"
#status = '404'
