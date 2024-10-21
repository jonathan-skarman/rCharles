#f = File.open("../example_requests/get-examples.request.txt", "r")
#input = f.read
#f.close


class HTTPrequest
  def initialize(request)
    @request_arr = request.split("\n")
    p @request_arr
    @request_arr2 = @request_arr.map {|el| el.split(" ")}

    @hash = {method: nil, resource: nil, version: nil, headers: nil, params: nil}

    @hash[:method], @hash[:resource], @hash[:version] = @request_arr2[0]

    #@hash[:headers] = Hash[@headers.map {|el| el.split(": ")}]



    if !(request[(request.length-2..request.length-1)] == "\n") #if final 2 of request isn't newline
      #@hash[:params] = Hash[@params.split("&").map {|el| el.split("=")}]
    end

    #get routes har params efter resource, efter ett & tecken utan mellanslag
    #post routes har en newline mellan headers och params

  end

  def init_params
    if @hash[:method] == "GET"
      @hash[:resource], @hash[:params] = @hash[:resource].split("?")
    elsif @hash[:method] == "POST"
      if !(request[(request.length-2..request.length-1)] == "\n") #if final 2 of request isn't newline
      #@hash[:params] = Hash[@params.split("&").map {|el| el.split("=")}]
      end
    else
      raise "Invalid HTTP method"
    end
    @hash[:params] = @hash[:params].split("&")
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
    #Hash[@headers.map {|el| el.split(": ")}]
  end

  def params
    @hash[:params]
    #Hash[@params.split("&").map {|el| el.split("=")}]
  end
end


input = "GET /examples HTTP/1.1\nHost: example.com\nUser-Agent: ExampleBrowser/1.0\nAccept-Encoding: gzip, deflate\nAccept: */*"
get = HTTPrequest.new(input)
p get.headers


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
