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
  property :created, DateTime
  property :updated, DateTime
end

DataMapper.auto_upgrade!

get '/' do
  @items = Item.all
  @articles = Article.all(:order => [:created.desc])
  @rss = SimpleRSS.parse open('http://slashdot.org/index.rdf')
  haml :index
end

### ITEM
get '/links' do
  @links = Item.all
  haml :link_all
end

get '/link/new' do
  haml :new
end

post '/link/new' do
  @item = Item.create(:name        => params[:name],
                      :url         => params[:url],
                      :description => params[:description])

  @errors = @item.errors
  redirect '/' if @errors.empty?
  haml :new
end

get '/link/edit/:id' do |id|
  @link = Item.get id
  @title = "Edit item #{@link.name}"
  haml :edit
end

post '/link/edit/:id' do |id|
  link = Item.get id
  link.update params

  redirect '/'
end

get '/link/delete/:id' do |id|
  @link = Item.get id
  #haml :delete
end

delete '/link/delete/:id' do |id|
  link = Item.get id
  link.destroy
  redirect '/links/all'
end

### ARTICLE
get '/articles' do
  @articles = Article.all
  haml :art_all
end

get '/article/new' do
  haml :art_new
end

post '/article/new' do
  @art = Article.create(:title  => params[:title],
                        :content => params[:content],
                        :created => DateTime.now)
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
  updated = {:updated => DateTime.now }
  art.update params.merge(updated)

  redirect '/'
end

get '/article/:id' do |id|
  @article = Article.get id
  haml :art_read
end
