# frozen_string_literal: true

# sluta klaga rubocop
class Request
	def initialize(request)
		@request_arr = request.split("\n").map { |el| el.split(': ') }
		@request_arr[0] = @request_arr[0][0].split
		@attributes = {
			method: @request_arr[0].shift.downcase.to_sym,
			resource: @request_arr[0].shift,
			version: @request_arr[0].shift,
			headers: [],
			params: nil
		}
		@request_arr.shift
		init_headers
		init_params
	end

	def init_headers
		@request_arr.each do |el|
			if el == []
				break
			end
			@attributes[:headers] += [el]
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
