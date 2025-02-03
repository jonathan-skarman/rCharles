# frozen_string_literal: true

require_relative 'tcp_server'
#require_relative 'router'
#require_relative 'request'
#require_relative 'response'
require 'slim'

def startup(router, server)
  server.start
end
