class Request
  def initialize(request)
    @request_arr = (request.split("\n")).map {|el| el.split(" ")}
    p @request_arr
    @attributes = {method: nil, resource: nil, version: nil, headers: nil, params: nil}
    @attributes[:method], @attributes[:resource], @attributes[:version] = @request_arr[0]
    init_params()
  end

  def init_params
    if @attributes[:method] == "GET"
      @attributes[:resource], @attributes[:params] = @attributes[:resource].split("?")
    elsif @attributes[:method] == "POST"

      #AHHHHHHHHHHHHH

    else
      raise "Invalid HTTP method"
    end

    if @attributes[:params] != nil
      @attributes[:params] = @attributes[:params].split("&")
    end
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
    #Hash[@headers.map {|el| el.split(": ")}]
  end

  def params
    @attributes[:params]
    #Hash[@params.split("&").map {|el| el.split("=")}]
  end
end

r = Request.new("GET /examples HTTP/1.1\nHost: example.com\nUser-Agent: ExampleBrowser/1.0\nAccept-Encoding: gzip, deflate\nAccept: */*\n")
