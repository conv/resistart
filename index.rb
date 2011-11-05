#!/usr/bin/env ruby

require "sinatra"
require "haml"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, 'sqlite3::memory:')

class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :url, String
end

Item.auto_migrate!

get '/' do
  @f = Item.all
  haml :index
end

#new
#
get '/new' do
  haml :new
end

post '/new' do
  @name = params[:name]
  @url = params[:url]

  item = Item.create(:name => params[:name], :url => params[:url])

  #haml :new
  redirect '/'
end

