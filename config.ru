# -*- coding: utf-8 -*-


require 'bundler'
Bundler.setup
Bundler.require

PATH = File.expand_path(File.dirname(__FILE__))
require "#{PATH}/app"
config = load_YAML("#{PATH}/schema/config_schema.yaml",
	               "#{PATH}/conf/config.yaml")

use Rack::Auth::Basic, 'DatabaseConnector' do |user, pass|
	user == config[:auth][:username] && pass == config[:auth][:password]
end

run DatabaseConnector
