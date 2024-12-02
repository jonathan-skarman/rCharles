# frozen_string_literal: true

require_relative 'lib/tcp_server'

server = HTTPServer.new(4567)
server.start
