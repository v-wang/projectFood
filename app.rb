require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'
require 'sinatra/base'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true
set :database, "sqlite3:form_app.sqlite3"


get '/' do
	erb :index
end
