#!/usr/bin/env ruby

require "sinatra"
require "haml"
require "dm-core"
require "dm-migrations"
require "dm-validations"

#use Rack::MethodOverride

## Database config
#
#

DataMapper::Logger.new('dm.log', :debug)
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/bmarks.db")

class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :url, String

  validates_format_of :url, :as => :url
end

#Item.auto_migrate!
Item.auto_upgrade!

## App
#
#

get '/' do
  @items = Item.all
  haml :index
end

get '/new' do
  haml :new
end

post '/new' do
  @item = Item.create(:name => params[:name], :url => params[:url])
  @err = @item.errors

  redirect '/' if @err.empty?
  haml :new
end

get '/edit/:id' do |id|
  @i = Item.get id
  haml :edit
end

put '/edit/' do 
  id = params[:id]

  unless id == ""
    name = params[:name]
    url = params[:url]

    unless name == "" && url == ""
      item = Item.get id
      item.name = name
      item.url = url
      item.save
    end
  end
  redirect '/'
end

delete '/delete' do
  @rm = Item.get(params[:id])
  @rm.destroy
  @r = true
  redirect '/'
end
