require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require './models'



enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true
set :database, "sqlite3:form_app.sqlite3"

# #####################
# FUNCTIONING RUBY 
get '/' do
	erb :index
	
end

get '/newsfeed' do
	erb :newsfeed
end

post '/signup' do
	current_user = User.find_by(email: params[:user][:email])
	# if User.find_by(email: params[:user][:email])
	if @user = current_user
		flash[:alert3] = "There is already an account for this email."
		redirect '/'
	else 	
		@user = User.create(params[:user])
		flash[:notice1] = "Welcome to Foodie Forum! New account created!"
		session[:user_id] = @user.id
		redirect '/user'
	end
end

get '/logged_in' do
	@user = User.find(session[:user_id])
	erb :landingtest

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
			redirect "/user"	
		end

	if current_user.nil?
		 flash[:alert1] = "user not found"
		 redirect '/'
	elsif current_user_pw.nil?
		flash[:alert2] = "incorrect password"
		redirect '/'
	else 	
		redirect "/"	

	end	
end	
# END FUNCTIONING RUBY 
# #####################


get '/logged_in' do
	@user = User.find(session[:user_id])
	erb :landingtest
end


get '/update' do
	erb :updateinfo
end


post '/update' do
	current_user = User.find(session[:user_id])
	
	current_user.update(:email => params[:email])
	# current_user = User.find(session[:user_id])
	# def current_user(x)
	# 	if session[:user_id].nil?
	# 			"Not signed in!"
	# 	else
	# 		User.find(session[:user_id])
	# 		"All good!"	
	# 	end
	# end
	# current_user(@user)
end


# get '/users/:id' do 
# 	@user = User.find(params[:id])
# 	erb :landingtest
# end	

# get '/users/by_email/:email' do
# 	@users = User.find_by(email: params[:email])
# end

# post '/users/sign_up' do
# 	if User.find_by(username: params[:username])
# 		flash[:notice] = "That email is taken! Try again!"
# 		redirect '/users/sign_up'
# 	else
# 		User.create(params)
# 		@users = User.all
# 		flash[:notice] = "thanks for signing up!"
# 		redirect '/'
# 	end
# end


get '/user' do
	erb :user
end

post '/post_rec' do
	# @post = Post.create(params[:post][:title][:body])
	@post = Post.new(params[:post])
	# @post.user_id =
	@post.postdate = Time.now
	@post.save
	# session[:user_id] = @user.id
	redirect '/user'
end







