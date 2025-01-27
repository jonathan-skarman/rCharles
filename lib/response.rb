# frozen_string_literal: true

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize; end # rubocop:disable Style/RedundantInitialize

	def send(route, session)
		content, status, content_type = status(route)
		session_response(status, content, content_type, session)
	end

	private

	# ja den är alldeles för lång, men liksom, det är en bara en if else. får skriva om någon annan gång
	def status(route) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
		if route == '404'
			content = '<h1>404 Not Found</h1>'
			status = '404'
			content_type = 'text/html'
		elsif	route.include?('.css')
			content = File.read(route)
			status = '200'
			content_type = 'text/css'
		elsif route.include?('.slim')
			content = Slim::Template.new('views/layout.slim').render { Slim::Template.new(route).render }
			status = '200'
			content_type = 'text/html'
		elsif route.include?('.html')
			content = File.read(route)
			status = '200'
			content_type = 'text/html'
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
end
