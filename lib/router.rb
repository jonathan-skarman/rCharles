# frozen_string_literal: true

# router klass för läsbarhet
class Router
	def initialize
		@routes = []
	end

	# takes method and resource and returns file adress for resource
	def route(method, routee)
		@routes.each do |route|
			return route[2], route[3] if route[0] == method && route[1] == routee
		end
		nil
	end

	def file_route(resource)
		if File.exist?("public/#{resource}")
			return "public/#{resource}"
		elsif File.exist?("public#{resource}")
			return "public#{resource}"
		elsif File.exist?("public/#{resource}.html")
			return "public/#{resource}.html"
		end

		nil
	end

	def get(resource, &block)
		params, route = params_route(resource)
		add_route(:get, route, params, block)
	end

	def post(resource, &block)
		params, route = params_route(resource)
		add_route(:post, route, params, block)
	end

	def params_route(resource)
		arr = resource.split('/')
		params = []
		route = ''

		i = 0
		while i < arr.length
			if arr[i][0] == ':'
				params << [arr[i], i]
				route += '/:'
			else
				route += "/#{arr[i]}"
			end
			i += 1
		end

		return params, route # rubocop:disable Style/RedundantReturn
	end

	private

	def add_route(method, route, params, block)
		@routes << [method, route, params, block]
	end
end
