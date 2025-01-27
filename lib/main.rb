# frozen_string_literal: true

require_relative 'tcp_server'
require 'slim'

def startup()
  server = HTTPServer.new(4567)
  server.start
end
