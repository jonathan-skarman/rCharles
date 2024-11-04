class Request
	def initialize(request)
		@request_arr = request.split("\n").map { |el| el.split(': ') }
		@request_arr[0] = @request_arr[0][0].split(' ')
		@attributes = {
			method: @request_arr[0][0].downcase.to_sym,
			resource: @request_arr[0][1],
			version: @request_arr[0][2],
			headers: [],
			params: nil
		}
		init_headers
		init_params
	end

	def init_headers
		i = 1
		while (i < @request_arr.length) && (@request_arr[i] != [])
			@attributes[:headers] += [@request_arr[i]]
			i += 1
		end

		@attributes[:headers].each do |arr|
			arr[0].sub! '-', '_'
			arr[0] = arr[0].to_sym
		end
		@attributes[:headers] = @attributes[:headers].to_h
	end

	def init_params
		if @attributes[:method] == :get
			@attributes[:resource], @attributes[:params] = @attributes[:resource].split('?')
		elsif @attributes[:method] == :post
			@attributes[:params] = @request_arr[@request_arr.length - 1][0] if @request_arr[@request_arr.length - 1] != []
		else
			raise 'Invalid HTTP method'
		end

		if @attributes[:params].nil?
			@attributes[:params] = {}
			return
		end

		# @attributes[:params] = {} if @attributes[:params].nil?
		# return unless @attributes[:params] != {}

		@attributes[:params] = @attributes[:params].
			split('&').
			map { |str| str.split('=') }.
			each { |arr| arr[0] = arr[0].to_sym }.
			to_h
	end

	def method
		@attributes[:method]
	end

	def resource
		@attributes[:resource]
	end

	def version
		@attributes[:version]
	end

	def headers
		@attributes[:headers]
		# Hash[@headers.map {|el| el.split(": ")}]
	end

	def params
		@attributes[:params]
		# Hash[@params.split("&").map {|el| el.split("=")}]
	end
end

def printer
	# r = Request.new("POST /login HTTP/1.1\nHost: foo.example\nContent-Type: application/x-www-form-urlencoded\nContent-Length: 39\n\nusername=grillkorv&password=verys3cret!")
	# r = Request.new("GET / HTTP/1.1\nHost: developer.mozilla.org\nAccept-Language: fr")
	r = Request.new("GET /examples HTTP/1.1\nHost: example.com\nUser-Agent: ExampleBrowser/1.0\nAccept-Encoding: gzip, deflate\nAccept: */*")

	p r.method #==> :post
	p r.resource #==> "/login"
	p r.version #==> "HTTP/1.1"
	p r.headers #==> {:Host=>"foo.example", :Content_Type=>"application/x-www-form-urlencoded", :Content_Length=>"39"}
	p r.params #==> ["username=grillkorv", "password=verys3cret!"]
end
printer
