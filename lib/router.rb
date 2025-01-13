# frozen_string_literal: true

# router klass för läsbarhet
class Router
	def initialize
		@routes_html = {}
		@routes_slim = {}
		route_file = File.read('../test_server/app.rb').split("\n")

		i = 0
		while i < route_file.length
			if route_file[i][0..2] == 'get' # rubocop:disable Style/IfUnlessModifier
				add_route_get(route_file, i)
			end
			i += 1
		end
	end

	def route(resource)
		@routes_html[resource]
	end

	private

	def route_exist?(resource)
		@routes.key?(resource)
	end

	def add_route_get(route_file, i) # rubocop:disable Metrics/AbcSize
		if route_file[i + 1][2..5] == 'html'
			route = route_file[i][6..(route_file[i].length - 6)]
			resource = route_file[i + 1][8..(route_file[i + 1].length - 3)]
			add_route_html(route, resource)
		elsif route_file[i + 1][2..5] == 'slim'
			route = route_file[i][6..(route_file[i].length - 6)]
			resource = route_file[i + 1][8..(route_file[i + 1].length - 3)]
			add_route_slim(route, resource)
		end
	end

	def add_route_html(route, resource)
		@routes_html[route] = "public/#{resource}"
	end

	def add_route_slim(route, resource)
		@routes_slim[route] = "views/#{resource}"
	end
end

Router.new
