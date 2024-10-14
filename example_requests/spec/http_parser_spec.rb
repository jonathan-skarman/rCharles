require_relative 'spec_helper'
require_relative '../lib/request'

describe 'Request' do

    describe 'Simple get-request' do
    
        it 'parses the http method' do
            @request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
            _(@request.method).must_equal :get
        end

        it 'parses the resource' do
            @request = Request.new(File.read('./spec/example_requests/get-index.request.txt'))
            _(@request.resource).must_equal "/"
        end


    end


end