class Request
  def initialize(request)
    @request_arr = (request.split("\n")).map {|el| el.split(" ")}
    #p @request_arr
    @attributes = {method: nil, resource: nil, version: nil, headers: [], params: nil}
    @attributes[:method], @attributes[:resource], @attributes[:version] = @request_arr[0]
    init_method()
    init_headers()
    init_params()
  end

  def init_method
    @attributes[:method] = @attributes[:method].downcase.to_sym
  end

  def init_headers
    i = 1
    while (i < @request_arr.length) && (@request_arr[i] != [])
      @attributes[:headers] += [@request_arr[i]]
      i += 1
    end

    @attributes[:headers].each {|arr| arr[0].sub! "-", "_" ; arr[0] = arr[0][(0..((arr[0].length) -2))].to_sym}
    @attributes[:headers] = @attributes[:headers].to_h
  end

  def init_params
    if @attributes[:method] == :get
      @attributes[:resource], @attributes[:params] = @attributes[:resource].split("?")
    elsif @attributes[:method] == :post
      if @request_arr[@request_arr.length-1] != []
        @attributes[:params] = @request_arr[@request_arr.length-1][0]
      end
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

def printer
  r = Request.new("POST /login HTTP/1.1\nHost: foo.example\nContent-Type: application/x-www-form-urlencoded\nContent-Length: 39\n\nusername=grillkorv&password=verys3cret!")
  p r.method #==> :post
  p r.resource #==> "/login"
  p r.version #==> "HTTP/1.1"
  p r.headers #==> [["Host:", "foo.example"], ["Content-Type:", "application/x-www-form-urlencoded"], ["Content-Length:", "39"]]
  p r.params #==> ["username=grillkorv", "password=verys3cret!"]
end

#printer()

#headers to hash
#params to hash
