require 'socket'
# frozen_string_literal: true

# sluta klaga rubocop
class HTTPServer
	def initialize(port)
		@port = port
	end

	def start
		server = TCPServer.new(@port)
		puts "Listening on #{@port}"
		# router = Router.new
		# router.add_route...

		while session = server.accept #error?
			data = ''
			while line = session.gets and line !~ /^\s*$/ #error?
				data += line
			end
			puts 'RECEIVED REQUEST'
			puts '-' * 40
			puts data
			puts '-' * 40

			# request = Request.new(data)
			# router.match_route(request)
			# Sen kolla om resursen (filen finns)

			# Nedanstående bör göras i er Response-klass
			html = '<h1>Hello, World!</h1>'

			session.print "HTTP/1.1 200\r\n"
			session.print "Content-Type: text/html\r\n"
			session.print "\r\n"
			session.print html
			session.close
		end
	end
end

server = HTTPServer.new(4567)
server.start
