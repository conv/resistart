require File.dirname(__FILE__) + '/spec_helper'

describe "resistart" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  context "#root" do
    it "should respond to '/'" do
      get '/'
      last_response.should be_ok
    end

    it "should have link to new article" do
      get '/'
      last_response.body.should include 'New article'
    end

    it "should have link to new link" do
      get '/'
      last_response.body.should include 'New link'
    end
  end

  context "Creating:" do
    context "- article" do
      it "should be possible to create article on separate page" do
        get '/article/new'
        last_response.should be_ok
      end

      it "should have a form to add article with Title and Content fields" do
        get '/article/new'
        last_response.body.should include('form', "Title", "Content")
      end
    end

    context "- link" do
      it "should be possible to add link on separate page" do
        get '/link/new'
        last_response.should be_ok
      end

      it "should have a form to add link with Url, Name and Description fields" do
        get '/link/new'
        last_response.body.should include('form', 'Url', 'Name', 'Description')
      end
    end
  end
end

