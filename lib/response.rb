# frozen_string_literal: true

# respons klass så HTTPserver klassen blir läsbar alls
class Response
	def initialize; end

	def send(route, session)
		content, headers, status, = status(route)
		session_response(status, headers, content, session)
	end

	def send_html(route, session)
		content = File.read("public/#{route}.html")
		status = '200'
		headers = headers('html', content)
		session_response(status, headers, content, session)
	end

	def send_slim(route, session)
		content = Slim::Template.new('views/layout.slim').render { Slim::Template.new("views/#{route}.slim").render }
		status = '200'
		headers = headers('html', content)
		session_response(status, headers, content, session)
	end

	private

	# ja den är alldeles för lång, men liksom, det är en bara en if else. får skriva om någon annan gång
	def status(route)
		if route == '404'
			content = '<h1>404 Not Found</h1>'
			status = '404'
			headers = headers('html', content)

		else
			key = route.split('.').last
			if binary_response?(key) # rubocop:disable Style/ConditionalAssignment
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

	def session_response(status, headers, content, session) # rubocop:disable Metrics/AbcSize
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

		if binary_response?(headers[2].split(':').last.split('/').last)
			puts 'binary content'
		else
			puts content
		end
		session.print content

		puts '-' * 40
		session.close
	end

	# returns an array with the important headers
	def mime(key) # rubocop:disable Metrics/MethodLength
		@mime = {
			'html' => 'text/html',
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

	def headers(key, content)
		headers = []
		headers << 'Server: Ruby HTTP Server'
		headers << 'Connection: close'
		headers << "Content-Type: #{mime(key)}"
		if binary_response?(key)
			headers << 'Content-Transfer-Encoding: binary'
			headers << 'Accept-Ranges: bytes'
			headers << "Content-Length: #{content.bytesize}"
		end

		headers
	end

	# skriven här nere så jag kan skriva om logiken lättare senare om fler filtyper ska läsas in binärt, för jag vete fan vilka som behöver det nu medans jag skriver denna # rubocop:disable Layout/LineLength
	def binary_response?(key)
		%w[jpg jpeg png gif svg ico pdf zip tar mp3 wav mp4 avi woff woff2 ttf eot].include?(key)
	end
end
