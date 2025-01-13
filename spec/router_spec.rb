# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/router'

describe 'Router' do
  describe 'add routes' do
    it 'adds a route to the html routes' do
      @router = Router.new
      @app = File.read('./example_apps/app.rb')
      _(@router.route('/')).must_equal 'public/index.html'
      _(@router.route('/index')).must_equal 'public/index.html'
      _(@router.route('/test')).must_equal 'public/test.html'
    end
  end
end
