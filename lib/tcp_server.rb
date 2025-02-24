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

	def start # rubocop:disable Metrics/AbcSize
		server = TCPServer.new(@port)
		puts "Listening on #{@port}"

		while @session = server.accept # rubocop:disable Lint/AssignmentInCondition
			data = parse_data(@session)

			terminal_print(data)

			request = Request.new(data)

			block = @router.route(request.method, request.resource)

			if !block.nil? # rubocop:disable Style/NegatedIfElseCondition
				block.call # calls the block from the route defined in app.rb
			else
				route = @router.file_route(request.resource)
				if route.nil?
					Response.new.send('404', @session)
				else
					Response.new.send(route, @session)
				end
			end

		end
	end

	def html(resource)
		Response.new.send_html(resource, @session)
	end

	def slim(resource)
		Response.new.send_slim(resource, @session)
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
