# frozen_string_literal: false

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
			$cookie = {}
			data = parse_data(@session)
			terminal_print(data)
			request = Request.new(data)

			a = cookie_parser(request.headers[:Cookie])
			$cookie = a if !a.nil?

			#route = route_from_resource(request.resource)
			params, block = @router.route(request.method, request.resource) #request.resource var route innan

			if !block.nil? # rubocop:disable Style/NegatedIfElseCondition
				block.call(params) # calls the block from the route defined in app.rb
			else # will never catch slim files here
				file_read_respond(request.resource)
			end
		end
	end

	def file_read_respond(route_ish)
		fileRoute = @router.file_route(route_ish)
		if fileRoute.nil? # rubocop:disable Style/ConditionalAssignment
			body = nil
		elsif binary_content?(fileRoute.split('/').last.split('.').last)
			body = File.binread(fileRoute)
		else
			body = File.read(fileRoute)
		end

		Response.new.send(body, fileRoute, @session)
	end

	def html(resource)
		file_read_respond(resource)
	end

	def slim(resource, params = {})
		context = SlimContext.new(params)
		route = "views/#{resource}.slim"

		body = Slim::Template.new('views/layout.slim').render(context) do
			Slim::Template.new(route).render(context)
		end

    Response.new.send(body, route, @session)
	end

	private

	def cookie_parser(cookie_header)
		return nil if cookie_header.nil?

		cookie_header = cookie_header[17..-3]

		i = 0
		hash = {}
		while i < cookie_header.length

			if cookie_header[i] == ':'
				key_temp = ""
				value_temp = ""
				while cookie_header[i] != '=' && i < cookie_header.length
					key_temp << cookie_header[i]
					i += 1
				end
				key_temp = key_temp.delete(':').to_sym
				i += 3 # skippar =>\"
				while cookie_header[i] != "\"" && i < cookie_header.length
					value_temp << cookie_header[i]
					i += 1
				end
				hash [key_temp] = value_temp
			end
			i += 1
		end

		hash
	end

	def params_definer(params_info, resource)
		params = {}

		params_info.each do |param|
			params[param[0].delete(':').to_sym] = resource.split('/')[param[1]].delete(':')
		end

		params
	end

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



class SlimContext
  attr_reader :params

  def initialize(params)
    @params = params
  end
end
