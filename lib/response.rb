# frozen_string_literal: true

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize; end # rubocop:disable Style/RedundantInitialize

	def send(route, session)
		content, status, content_type = status(route)
		session_response_dev(status, content, content_type, session)
	end

	def send_html(route, session)
		content = File.read("public/#{route}.html")
		status = '200'
		content_type = 'text/html'
		session_response_dev(status, content, content_type, session)
	end

	def send_slim(route, session)
		content = Slim::Template.new('views/layout.slim').render { Slim::Template.new("views/#{route}.slim").render }
		status = '200'
		content_type = 'text/html'
		session_response_dev(status, content, content_type, session)
	end

	private

	# ja den är alldeles för lång, men liksom, det är en bara en if else. får skriva om någon annan gång
	def status(route)
		if route == '404'
			content = '<h1>404 Not Found</h1>'
			status = '404'
			content_type = 'text/html'
		elsif	route.include?('.css')
			content = File.read(route)
			status = '200'
			content_type = 'text/css'
		else
			content = '<h1>404 File type Not Found</h1><p>response class, status method</p>'
			status = '404'
			content_type = 'text/html'
		end
		[content, status, content_type]
	end

	def session_response(status, content, content_type, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: #{content_type}\r\n" # content_type = "text/css" / "text/html"
		session.print "\r\n"
		session.print content
		session.close
	end

	def session_response_dev(status, content, content_type, session)
		puts '-' * 40
		p 'SESSION RESPONSE'
		puts

		session.print "HTTP/1.1 #{status}\r\n"
		p "HTTP/1.1 #{status}\r\n"

		session.print "Content-Type: #{content_type}\r\n" # content_type = "text/css" / "text/html"
		p "Content-Type: #{content_type}\r\n" # content_type = "text/css" / "text/html"

		session.print "\r\n"
		p "\r\n"

		session.print content
		p content

		session.close
		puts '-' * 40
	end
end
