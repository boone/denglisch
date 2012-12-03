# encoding: utf-8

ENV['RACK_ENV'] = 'test'
# set :environment, :test

require File.dirname(__FILE__) + '/../denglisch'

require 'rspec'
require 'rack/test'

describe 'The Denglisch App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'has a homepage' do
    get '/'
    last_response.should be_ok
    last_response.body.should =~ /Enter a German or English word/
  end
  
  it 'should be searchable' do
    Word.create(german: 'prüfung', english: 'test')
    Word.create(german: 'testat', english: 'test')
    Word.create(german: 'froh', english: 'happy')
    
    post '/search', { query: 'test' }
    
    last_response.should be_ok
    last_response.body.should =~ /Exact matches/
  end

  it 'should say not found when there are no matches' do
    # no pre-set words for this test
    
    post '/search', { query: 'nothing' }
    
    last_response.should be_ok
    last_response.body.should =~ /No results were found/
  end
end
