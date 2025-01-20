# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/router'

describe 'Router' do
  describe 'basic routes /' do
    it 'adds a route to the html routes' do
      @router = Router.new
      @app = File.read('./example_apps/app1.rb')
      _(@router.route('/')).must_equal 'public/index.html'
    end
  end

  describe 'basic routes /index' do
    it 'adds a route to the html routes' do
      @router = Router.new
      @app = File.read('./example_apps/app1.rb')
      _(@router.route('/index')).must_equal 'public/index.html'
    end
  end

  describe 'basic routes /test' do
    it 'adds a route to the html routes' do
      @router = Router.new
      @app = File.read('./example_apps/app1.rb')
      _(@router.route('/test')).must_equal 'public/test.html'
    end
  end
end
