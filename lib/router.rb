# router klass för läsbarhet
class Router
	def initialize
		@routes = []
	end

	# takes method and resource and returns file adress for resource
	def route(method, route) # resource or route???
		@routes.each do |routee|
			next unless route.match?(routee[1]) && (routee[0] == method)

			m = route.match(routee[1])
			params = m.named_captures

			return params, routee[3]
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

	def params_route(resource) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
		i = 0
		resource2 = '^'
		while i < resource.length
			if resource[i] == ':'
				j = i + 1
				var = "" # rubocop:disable Style/StringLiterals
				while resource[j] != '/' && j < resource.length
					var += resource[j] unless resource[j].nil? || resource[j] == '/' # rubocop:disable Metrics/BlockNesting
					j += 1
				end
				resource2 << "(?<#{var}>\\w+)"
				i = j - 1
			else
				resource2 << resource[i]
			end
			i += 1
		end
		resource2 << "(\/?)$" # rubocop:disable Style/RedundantStringEscape

		route = Regexp.new(resource2)
		params_keys = resource.scan(/:(\w+)/).flatten.map(&:to_sym)

		[params_keys, route]
	end

	private

	def add_route(method, route, params, block)
		@routes << [method, route, params, block]
		# p @routes
	end
end
