# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'router'

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

			Response.new.send(router.route(request.method, request.resource), @session)
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
		if route == '404'
			html = '<h1>404 Not Found</h1>'
			status = '404'
			session_response_html(status, html, session)
		elsif route.include?('.css')
			status = '200'
			css = File.read(route)
			session_response_css(status, css, session)
		else
			html, status = html_status(route)
			session_response_html(status, html, session)
		end
	end

	private

	def html_status(route)
		html = File.read(route)
		status = '200'
		[html, status]
	end

	def session_response_html(status, html, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: text/html\r\n"
		session.print "\r\n"
		session.print html
		session.close
	end

	def session_response_css(status, css, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: text/css\r\n"
		session.print "\r\n"
		session.print css
		session.close
	end
end

# html = "<h1>404 Not Found</h1>"
# status = '404'
