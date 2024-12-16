require_relative 'spec_helper' # rubocop:disable Layout/EndOfLine
require_relative '../lib/request'

describe 'Request' do # rubocop:disable Metrics/BlockLength
	describe 'Simple get-request' do
		it 'parses the http method' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			_(@request.method).must_equal :get
		end

		it 'parses the resource' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			_(@request.resource).must_equal '/'
		end

		it 'parses the version' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			_(@request.version).must_equal 'HTTP/1.1'
		end

		it 'parses the headers' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			@hash = { Host: 'developer.mozilla.org', Accept_Language: 'fr' }
			_(@request.headers).must_equal @hash
		end

		it 'parses the params' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			assert_nil @request.params
		end
	end

	describe 'Simple post-request' do
		it 'parses the http method' do
			@request = Request.new(File.read('./spec/example_requests/post-login.request.txt'))
			_(@request.method).must_equal :post
		end

		it 'parses the resource' do
			@request = Request.new(File.read('./spec/example_requests/post-login.request.txt'))
			_(@request.resource).must_equal '/login'
		end

		it 'parses the version' do
			@request = Request.new(File.read('./spec/example_requests/post-login.request.txt'))
			_(@request.version).must_equal 'HTTP/1.1'
		end

		it 'parses the headers' do
			@request = Request.new(File.read('./spec/example_requests/post-login.request.txt'))
			@hash = { Host: 'foo.example', Content_Type: 'application/x-www-form-urlencoded', Content_Length: '39' }
			_(@request.headers).must_equal @hash
		end

		it 'parses the params' do
			@request = Request.new(File.read('./spec/example_requests/post-login.request.txt'))
			@hash = { username: 'grillkorv', password: 'verys3cret!' } # username=grillkorv&password=verys3cret!
			_(@request.params).must_equal @hash
		end
	end

	describe 'Middle get-request' do
		it 'parses the http method' do
			@request = Request.new(File.read('./spec/example_requests/get-examples.request.txt'))
			_(@request.method).must_equal :get
		end

		it 'parses the resource' do
			@request = Request.new(File.read('./spec/example_requests/get-examples.request.txt'))
			_(@request.resource).must_equal '/examples'
		end

		it 'parses the version' do
			@request = Request.new(File.read('./spec/example_requests/get-examples.request.txt'))
			_(@request.version).must_equal 'HTTP/1.1'
		end

		it 'parses the headers' do
			@request = Request.new(File.read('./spec/example_requests/get-examples.request.txt'))
			@hash = { Host: 'example.com', User_Agent: 'ExampleBrowser/1.0', Accept_Encoding: 'gzip, deflate', Accept: '*/*' }
			_(@request.headers).must_equal @hash
		end

		it 'parses the params' do
			@request = Request.new(File.read('./spec/example_requests/get-examples.request.txt'))
			assert_nil @request.params
		end
	end

	describe 'Complex get-request' do
		it 'parses the http method' do
			@request = Request.new(File.read('./spec/example_requests/get-fruits-with-filter.request.txt'))
			_(@request.method).must_equal :get
		end

		it 'parses the resource' do
			@request = Request.new(File.read('./spec/example_requests/get-fruits-with-filter.request.txt'))
			_(@request.resource).must_equal '/fruits'
		end

		it 'parses the version' do
			@request = Request.new(File.read('./spec/example_requests/get-fruits-with-filter.request.txt'))
			_(@request.version).must_equal 'HTTP/1.1'
		end

		it 'parses the headers' do
			@request = Request.new(File.read('./spec/example_requests/get-fruits-with-filter.request.txt'))
			@hash = { Host: 'fruits.com', User_Agent: 'ExampleBrowser/1.0', Accept_Encoding: 'gzip, deflate', Accept: '*/*' }
			_(@request.headers).must_equal @hash
		end

		it 'parses the params' do
			@request = Request.new(File.read('./spec/example_requests/get-fruits-with-filter.request.txt'))
			@hash = { type: 'bananas', minrating: '4' }
			_(@request.params).must_equal @hash
		end
	end
end
