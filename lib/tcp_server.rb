# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

# sluta klaga rubocop
class HTTPServer
	def initialize(port, router)
		@port = port
		@router = router
	end

	def start
		server = TCPServer.new(@port)
		puts "Listening on #{@port}"

		while @session = server.accept # rubocop:disable Lint/AssignmentInCondition
			data = parse_data(@session)

			terminal_print(data)

			request = Request.new(data)

			block = @router.route(request.method, request.resource)

			if !block.nil? # rubocop:disable Style/NegatedIfElseCondition
				block.call # calls the block from the route defined in app.rb
			else # will never catch slim files here
				file_read_respond(request.resource)
			end
		end
	end

	def file_read_respond(resource)
		route = @router.file_route(resource)
		if binary_content?(resource.split('.').last) # rubocop:disable Style/ConditionalAssignment
			body = File.binread(route)
		else
			body = File.read(route)
		end

		Response.new.send_2(body, route, @session)
	end

	def html(resource)
		file_read_respond(resource)
	end

	def slim(resource)
		route = "views/#{resource}.slim"
		body = Slim::Template.new('views/layout.slim').render { Slim::Template.new("views/#{resource}.slim").render }
		Response.new.send_2(body, route, @session)
	end

	private

	def terminal_print(data)
		puts '-' * 40
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
