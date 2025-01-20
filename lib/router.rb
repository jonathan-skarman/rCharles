# frozen_string_literal: true

# router klass för läsbarhet
class Router
	def initialize
		# routes = {}
		@route_file = File.read('../test_server/app.rb').split("\n")
	end

	# takes method and resource and returns file adress for resource
	def route(method, resource)
		return "public#{resource}" if resource.include?('.css')

		line_num = find_route(method, resource)

		if line_num.nil?
			'404'
		else
			find_resource(line_num)
		end
	end

	private

	def find_route(method, resource)
		i = 0
		while i < @route_file.length
			return i if @route_file[i][0..2] == method[0..2] && @route_file[i][6..(5 + resource.length)] == resource

			i += 1
		end
		p '404 route not found in app.rb'
		nil
	end

	def find_resource(line) # rubocop:disable Metrics/AbcSize
		while line < @route_file.length
			if @route_file[line][2..5] == 'html'
				x = "public/#{@route_file[line][8..(@route_file[line].length - 3)]}.html"
				p x
				return x
			elsif @route_file[line][2..5] == 'slim'
				x = "views/#{@route_file[line][8..(@route_file[line].length - 3)]}.slim"
				p x
				return x
			end

			line += 1
		end
		p '404 resource not found'
		nil
	end
end

Router.new
