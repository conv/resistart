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
  property :description, String

  validates_format_of :url, :as => :url
end

class Article
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :content, Text
end

#Item.auto_upgrade!
Item.auto_migrate!
Article.auto_migrate!

DataMapper.finalize

get '/' do
  @items = Item.all
  @articles = Article.all
  haml :index
end


### ITEM
get '/item/new' do
  haml :new
end

post '/item/new' do
  @item = Item.create(:name        => params[:name],
                      :url         => params[:url],
                      :description => params[:description])
  @err = @item.errors

  redirect '/' if @err.empty?
  haml :new
end

get '/item/edit/:id' do |id|
  @item = Item.get id
  @title = "Edit item #{@item.name}"
  haml :edit
end

post '/item/edit/:id' do |id|
  i = Item.get id
  i.update params

  redirect '/'
end

delete '/item/delete' do
  @rm = Item.get(params[:id])
  @rm.destroy
  @r = true
  redirect '/'
end

### ARTICLE
get '/article/show/:id' do |id|
  @article = Article.get id
  haml :read_art
end

get '/article/new' do
  haml :articlenew
end

post '/article/new' do
  @art = Article.create(:title  => params[:title],
                        :content => params[:content])
  @err = @art.errors

  redirect '/' if @err.empty?
  haml :articlenew
end

get '/article/edit/:id' do |id|
  @article = Article.get id
  haml :art_edit
end

post '/article/edit/:id' do |id|
  art = Article.get id
  art.update params

  redirect '/'
end

