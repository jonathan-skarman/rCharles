require_relative 'spec_helper'
require_relative '../lib/tcp_server'

describe 'HTTPServer' do
	describe 'Simple get-request' do
		it 'routes simple request' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			@router = Router.new
			_(@router.add_route(@request.resource)).must_equal './public/index.html'
		end

		it 'routes simple request' do
			@request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
			@router = Router.new
			_(@router.add_route(@request.resource)).must_equal './public/index.html'
		end
	end
end
