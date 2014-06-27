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

get '/signup' do
	erb :signuptest
end

post '/signup' do
	@user = User.create(params[:user])
	flash[:notice] = "Welcome to Foodie Forum! New account created!"
	session[:user_id] = @user.id
	redirect '/logged_in'
end

get '/logged_in' do
	@user = User.find(session[:user_id])
	erb :landingtest
end

get '/signin' do
	erb :signintest
end	

post '/signin' do
	current_user = User.find_by_email(params[:user][:email])
	current_user_pw = User.find_by_password params[:user][:password]
	if current_user.nil? 
		 "User not found!"
	else 
		if current_user_pw.nil?
			"WRONG PW"
		else 	
			redirect "/"	
		end
	end	
end	

get '/index' do 
	erb :index
end

get '/update' do
	def current_user
		if session[:user_id].nil?
			"Not signed in!"
		else
			User.find(session[:user_id])
			"All good!"	
		end
	end
	current_user
	erb :updateinfo
end

post '/update' do

end

get '/profile' do
	erb :