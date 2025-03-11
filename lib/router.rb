# frozen_string_literal: true

# router klass för läsbarhet
class Router
	def initialize
		@routes = []
	end

	# takes method and resource and returns file adress for resource
	def route(method, routee)
		@routes.each do |route|
			next unless routee.match?(route[1]) && (route[0] == method)

			m = routee.match(route[1])
			params = m.named_captures
			p params
			return params, route[3]
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

	#####
	# def params_route(resource)
	#	arr = resource.split('/')
	#	params = []
	#	route = ''

	#	i = 0
	#	while i < arr.length
	#		if arr[i][0] == ':'
	#			params << [arr[i], i]
	#			route += '/:'
	#		else
	#			route += "/#{arr[i]}"
	#		end
	#		i += 1
	#	end

	#	return params, route
	# end
	#####
	def params_route(resource) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
		i = 0
		resource2 = "" # rubocop:disable Style/StringLiterals
		while i < resource.length
			if resource[i] == ':'
				j = i
				var = "" # rubocop:disable Style/StringLiterals
				while resource[j] != '/' && j < resource.length
					j += 1
					var += resource[j] unless resource[j].nil? || resource[j] == '/'
				end
				resource2 += "(?<#{var}>\\w+)/"
				i = j
			else
				resource2 += resource[i]
				i += 1
			end
		end
		# resource2 = resource.gsub(/(:\w+)/, '(\w+)')

		route = Regexp.new(resource2)
		params_keys = resource.scan(/:(\w+)/).flatten.map(&:to_sym)

		p route
		p params_keys

		[params_keys, route]
	end
	#####

	private

	def add_route(method, route, params, block)
		@routes << [method, route, params, block]
	end
end
