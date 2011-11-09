#!/usr/bin/env ruby

require "sinatra"
require "haml"
require "dm-core"
require "dm-migrations"
require "dm-validations"

#use Rack::MethodOverride

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

get '/' do
  @items = Item.all
  haml :index
end

get '/url/:id' do |id|
  @i = Item.get id
  @i.name + " " + @i.url
end

#New url

get '/new' do
  haml :new
end

post '/new' do
  @item = Item.create(:name => params[:name], :url => params[:url])
  @err = @item.errors

  redirect '/' if @err.empty?
  haml :new
end

delete '/url/' do
  @rm = Item.get(params[:id])
  @rm.destroy

  redirect '/'
end
