#!/usr/bin/env ruby

require "sinatra"
require "haml"
require "dm-core"
require "dm-migrations"
require "dm-validations"

DataMapper::Logger.new('dm.log', :debug)
DataMapper.setup(:default, 'sqlite3::memory:')

class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :url, String

  validates_format_of :url, :as => :url
end

Item.auto_migrate!

get '/' do
  @items = Item.all
  haml :index
end

#New url

get '/new' do
  #@item = Item.create(:name => params[:name], :url => params[:url])
  haml :new
end

post '/new' do
  @item = Item.create(:name => params[:name], :url => params[:url])
  @err = @item.errors

  redirect '/' if @err.empty?
  haml :new
end
