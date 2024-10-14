#f = File.open("../example_requests/get-examples.request.txt", "r")
#input = f.read
#f.close


class HTTPrequest
  def initialize(request)
    @request_arr = request.split("\n")
  end

  def parser
    @hash = {method: nil, resource: nil, version: nil, headers: nil, params: nil}

    @request_arr.map {|el| el.include?("GET")}
  end

  def method
    @hash[:method]
  end

  def resource
    @hash[:resource]
  end

  def version
    @hash[:version]
  end

  def headers
    @hash[:headers]
  end

  def params
    @hash[:params]
  end
end


input = "GET /examples HTTP/1.1\nHost: example.com\nUser-Agent: ExampleBrowser/1.0\nAccept-Encoding: gzip, deflate\nAccept: */*"
get = HTTPrequest.new(input)
p get.parser


# p request.method   #=> 'GET'
# p request.resource #=> '/'
# p request.version  #=> 'HTTP/1.1'
# p request.headers  #=> {'Host' => 'developer.mozilla.org', 'Accept-Language' => 'fr'}
# p request.params   #=> {}
# GET /examples HTTP/1.1\n
# Host: example.com\n
# User-Agent: ExampleBrowser/1.0\n
# Accept-Encoding: gzip, deflate\n
# Accept: */*\n
# \n
