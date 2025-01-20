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
