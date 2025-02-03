# frozen_string_literal: true

# router klass för läsbarhet
class Router
	def initialize
		@routes = []
	end

	# takes method and resource and returns file adress for resource
	def route(method, resource)
		@routes.each do |route|
			return route[2] if route[0] == method && route[1] == resource
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
		add_route(:get, resource, block)
	end

	def post(resource, &block)
		add_route(:post, resource, block)
	end

	private

	def add_route(method, resource, block)
		@routes << [method, resource, block]
	end
end
