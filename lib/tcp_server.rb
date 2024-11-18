# frozen_string_literal: true
require 'socket'
require_relative 'request'

# router klass eftersom den tydligen behövs
class Router
	def initialize
	end

	def add_route
	end

	def match_route(resource)
	end

	def exist?(resource)
		File.exist?("./public/#{resource}.html")
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
		# router = Router.new
		# router.add_route...

		while session = server.accept # rubocop:disable Lint/AssignmentInCondition
			data = ''
			while line = session.gets and line !~ /^\s*$/ # rubocop:disable Lint/AssignmentInCondition
				data += line
			end
			puts 'RECEIVED REQUEST'
			puts '-' * 40
			puts data
			puts '-' * 40

			request = Request.new(data)
			html, status = Response.new.send(request.resource)

			# Nedanstående bör göras i er Response-klass
				#men då behöver jag lista ut hur jag skickar session till response-klassen
			session.print "HTTP/1.1 #{status}\r\n"
			session.print "Content-Type: text/html\r\n"
			session.print "\r\n"
			session.print html
			session.close
		end
	end
end

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize
	end

	def send(resource)
		if resource == "/"
			resource = "index"
		end

		if File.exist?("./public/#{resource}.html")
			html = File.read("./public/#{resource}.html")
			status = 200
		else
			html = '<h1>404 Not Found</h1>'
			status = 404
		end

		return html, status
	end
end
