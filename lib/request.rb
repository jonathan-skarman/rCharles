# frozen_string_literal: true

# sluta klaga rubocop
class Request
	def initialize(request)
		@request_arr = request.split("\n").map { |el| el.split(': ') }
		@request_arr[0] = @request_arr[0][0].split
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
		#inte fin kod, men måste ha startpunk i = 1, vilket inte går med .each eller .map
		#dessutom behövs [] för att hitta var headers slutar och params börjar i post requests
		#kanske kan optimera via att splitta upp dom och inte kolla efter [] vid get requests, men då måste mycket kod repeteras
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
		case @attributes[:method]
		when :get
			@attributes[:resource], @attributes[:params] = @attributes[:resource].split('?')
		when :post
			@attributes[:params] = @request_arr[@request_arr.length - 1][0] if @request_arr[@request_arr.length - 1] != []
		else
			raise 'Invalid HTTP method'
		end

		if @attributes[:params].nil?
			return
		end

		@attributes[:params] = @attributes[:params]
		.split('&')
		.map { |str| str.split('=') }
		.each { |arr| arr[0] = arr[0].to_sym }
		.to_h
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
	end

	def params
		@attributes[:params]
	end
end
