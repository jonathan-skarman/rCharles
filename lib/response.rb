# frozen_string_literal: true

# respons klass så HTTPserver klassen blir läsbar alls
class Response # rubocop:disable Metrics/ClassLength
	def initialize; end # rubocop:disable Style/RedundantInitialize

	def send(route, session)
		puts '-' * 80
		puts 'problem, ska inte använda denna metoden'
		puts '-' * 80
		content, headers, status, = status(route)
		session_response(status, headers, content, session)
	end

	def send_2(body, route, session) # rubocop:disable Naming/VariableNumber
		if body.nil? # rubocop:disable Style/ConditionalAssignment
			status = '404'
			body = '<h1>404 Not Found</h1>'
			headers = headers('html', body)
		else
			status = '200'
			headers = headers(route, body)
		end
		session_response(status, headers, body, session)
	end

	private

	# ja den är alldeles för lång, men liksom, det är en bara en if else. får skriva om någon annan gång
	def status(route) # rubocop:disable Metrics/AbcSize
		if route.nil?
			content = '<h1>404 Not Found</h1>'
			status = '404'
			headers = headers('html', content)

		else

			key = route.split('.').last
			if binary_content?(key) # rubocop:disable Style/ConditionalAssignment
				content = File.binread(route)
			else
				content = File.read(route)
			end
			status = '200'
			headers = headers(key, content)

			if content.nil? || status.nil? || headers.nil?
				content = '<h1>404 File type Not Found</h1><p>in response class, in the status method</p>'
				status = '404'
				headers = headers('html', content)
			end
		end
		[content, headers, status]
	end

	def session_response(status, headers, body, session) # rubocop:disable Metrics/AbcSize
		puts '-' * 40
		puts 'RESPONSE'
		puts '-' * 40

		puts "HTTP/1.1 #{status}\r\n"
		session.print "HTTP/1.1 #{status}\r\n"

		headers.each do |header|
			puts "#{header}\r\n"
			session.print "#{header}\r\n"
		end

		puts "\r\n"
		session.print "\r\n"

		if binary_content?(headers[2].split(':').last.split('/').last)
			puts 'binary content'
		else
			puts body
		end
		session.print body

		puts '-' * 40
		session.close
	end

	# returns an array with the important headers
	def mime(key) # rubocop:disable Metrics/MethodLength
		@mime = {
			'html' => 'text/html',
			'htm' => 'text/html',
			'css' => 'text/css',
			'js' => 'text/javascript',
			'json' => 'application/json',
			'xml' => 'application/xml',
			'jpg' => 'image/jpeg',
			'jpeg' => 'image/jpeg',
			'png' => 'image/png',
			'gif' => 'image/gif',
			'svg' => 'image/svg+xml',
			'ico' => 'image/x-icon',
			'pdf' => 'application/pdf',
			'zip' => 'application/zip',
			'tar' => 'application/x-tar',
			'mp3' => 'audio/mpeg',
			'wav' => 'audio/wav',
			'mp4' => 'video/mp4',
			'avi' => 'video/x-msvideo',
			'woff' => 'font/woff',
			'woff2' => 'font/woff2',
			'ttf' => 'font/ttf',
			'eot' => 'application/vnd.ms-fontobject'
		}

		@mime[key]
	end

	def headers(route, body)
		key = route.split('.').last
		headers = []
		headers << 'Server: Ruby HTTP Server'
		headers << 'Connection: close'
		headers << "Content-Type: #{mime(key)}"
		if binary_content?(key)
			headers << 'Content-Transfer-Encoding: binary'
			headers << 'Accept-Ranges: bytes'
			headers << "Content-Length: #{body.bytesize}"
		end

		headers
	end
end

	def binary_content?(key)
		%w[jpg jpeg png gif svg ico pdf zip tar mp3 wav mp4 avi woff woff2 ttf eot].include?(key)
	end
