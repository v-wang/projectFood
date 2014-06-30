require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require './models'



enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true
configure(:development){set :database, "sqlite3:form_app.sqlite3"}


helpers do
  def active_user
  	 session[:user_id].nil? ? nil : User.find(session[:user_id])
   #  if session[:user_id] != nil 
   #    	if session[:user_id] <= User.last.id
   #    	return User.find(session[:user_id])
   #  	else
   #    	session[:user_id] = nil
   #    	return nil
   #  	end
   #  else
   #    return nil
  	# end
  end
end


# #####################
# FUNCTIONING RUBY 
get '/' do
	erb :index
	
end

get '/newsfeed' do
	# POST THE LAST 10 MOST RECENT POSTS FROM ALL USERS
	@allposts = Post.all.order(:postdate).limit(10)
	erb :newsfeed
end

# check if an email matches any email in our user table database, if not create new user id and session id.
post '/signup' do
	existing_user = User.find_by(email: params[:user][:email])
	if @user = existing_user
		flash[:alert3] = "There is already an account for this email. "
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

# if user email and password matches values in database, create a session id and redirect to newsfeed.
# else flash alerts for user/password error
post '/signin' do
	current_user = User.find_by_email(params[:user][:email])
	current_user_pw = User.find_by_password params[:user][:password]
# if the email entered exists, assign instance variable user, if user password matches, create session id
# for some reason, even when there is nothing in the input fields and we hit enter, we are redirected to newsfeed
	if current_user != nil
		@user = current_user
		if @user.password == params[:user][:password]
			session[:user_id]= @user.id
			redirect '/user'
		else
			flash[:alert2] = "incorrect password"
			redirect '/'
		end
	else current_user.nil?
		 flash[:alert1] = "user not found"
		 redirect '/'
	# elsif current_user_pw.nil?
	# 	flash[:alert2] = "incorrect password"
	# 	redirect '/'
	# else 	
	# 	redirect "/"	
	end	
end	
# END FUNCTIONING RUBY 
# #####################

# get '/user/:id' do
#   @user = User.find(params[:id])
#   erb :user
# end


get '/sign-out' do
  session[:user_id] = nil
  redirect '/'

end  

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
	if active_user != nil
	@post = active_user.posts.last
		erb :user
	else
		redirect '/'
	end

end

post '/post_rec' do
	# @post = Post.create(params[:post][:title][:body])
	@post = Post.new(params[:post])
	@post.user_id = active_user.id
	@post.postdate = Time.now
	@post.save
	# session[:user_id] = @user.id
	redirect '/user'
end







