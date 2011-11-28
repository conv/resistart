#!/usr/bin/env ruby

require "sinatra"
require "haml"
require "dm-core"
require "dm-migrations"
require "dm-validations"
require "simple-rss"
require "open-uri"

#use Rack::MethodOverride

## Database config
#
#

DataMapper::Logger.new('dm.log', :debug)

DataMapper.setup(:default, (ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/mydatabase.db"))

class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :url, String
  property :description, Text

  validates_format_of :url, :as => :url
end

class Article
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :content, Text
  property :created, Date
end

DataMapper.auto_upgrade!

get '/' do
  @items = Item.all
  @articles = Article.all
  @rss = SimpleRSS.parse open('http://slashdot.org/index.rdf')
  haml :index
end

### ITEM
get '/link/new' do
  haml :new
end

post '/link/new' do
  @item = Item.create(:name        => params[:name],
                      :url         => params[:url],
                      :description => params[:description])
  @err = @item.errors

  redirect '/' if @err.empty?
  haml :new
end

get '/links' do
  @links = Item.all
  haml :link_all
end

get '/link/edit/:id' do |id|
  @item = Item.get id
  @title = "Edit item #{@item.name}"
  haml :edit
end

post '/link/edit/:id' do |id|
  i = Item.get id
  i.update params

  redirect '/'
end

get '/link/delete/:id' do |id|
  @link = Item.get id
  #haml :delete
end

delete '/link/:id' do |id|
  link = Item.get id
  link.destroy
  redirect '/links/all'
end

### ARTICLE
get '/article/read/:id' do |id|
  @article = Article.get id
  haml :art_read
end

get '/articles' do
  @articles = Article.all
  haml :art_all
end

get '/article/new' do
  haml :art_new
end

post '/article/new' do
  @art = Article.create(:title  => params[:title],
                        :content => params[:content])
  @err = @art.errors

  redirect '/' if @err.empty?
  haml :art_new
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

