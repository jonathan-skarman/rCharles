# frozen_string_literal: true

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize; end # rubocop:disable Style/RedundantInitialize

	def send(route, session)
		if route == '404'
			html = '<h1>404 Not Found</h1>'
			status = '404'
			session_response_html(status, html, session)
		elsif route.include?('.css')
			status = '200'
			css = File.read(route)
			session_response_css(status, css, session)
		else
			if route.include?('.slim')
				html, status = slim_status(route)
			elsif route.include?('.html')
				html, status = html_status(route)
			else
				raise 'invalid route - neither html nor slim'
			end
			session_response_html(status, html, session)
		end
	end

	private

	def html_status(route)
		html = File.read(route)
		status = '200'
		[html, status]
	end

	def slim_status(route)
		layout_template = Slim::Template.new('views/layout.slim')
		content_template = Slim::Template.new(route)
		html = layout_template.render { content_template.render } # makes layout and routed slim files work
		status = '200'
		[html, status]
	end

	def session_response_html(status, html, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: text/html\r\n"
		session.print "\r\n"
		session.print html
		session.close
	end

	def session_response_css(status, css, session)
		session.print "HTTP/1.1 #{status}\r\n"
		session.print "Content-Type: text/css\r\n"
		session.print "\r\n"
		session.print css
		session.close
	end
end
