# -*- coding: utf-8 -*-


require "#{File.dirname(__FILE__)}/lib/Hash"
require "#{File.dirname(__FILE__)}/lib/load_YAML"
require "#{File.dirname(__FILE__)}/lib/create_uri"
require "#{File.dirname(__FILE__)}/lib/DBI"
require "#{File.dirname(__FILE__)}/lib/create_output"

class DatabaseConnector < Sinatra::Base
  configure :development do
    Bundler.require :development
    register Sinatra::Reloader

    disable :show_exceptions
  end


  get '/dbc.xml' do
    content_type 'xml'

    if params[:query].nil? then
      raise 'Invalid parameter: query'
    end

    output = create_output(params[:query])
    output.to_xml(:root => 'result', :skip_types => true, :dasherize => false)
  end

  get '/dbc.json' do
    content_type 'json'

    if params[:query].nil? then
      raise 'Invalid parameter: query'
    end

    output = create_output(params[:query])
    output.to_json
  end


  error RuntimeError, Mysql::Error, PG::Error do
    output = {:message => request.env['sinatra.error'].message}

    if request.path_info == '/dbc.xml' then
      content_type 'xml'
      output.to_xml(:root => 'error')
    elsif request.path_info == '/dbc.json' then
      content_type 'json'
      output.to_json
    end
  end
end
