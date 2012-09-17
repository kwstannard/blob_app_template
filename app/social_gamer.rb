require 'sinatra'
require 'sinatra/flash'
require 'sinatra/r18n'
require 'sinatra/session'
require 'haml'
require File.expand_path("../../lib/application.rb", __FILE__)

app = Application.new(name: 'Your App')

set :title, app.name
set :views, File.expand_path("../../views/", __FILE__)
set :session_fail, '/'
set :session_secret, rand(36**16).to_s(36)
set :public_folder, File.expand_path('../../public/', __FILE__)

configure :development do 
  enable :logging, :dump_errors, :raise_errors
end

get '/' do
  haml :'main/_dashboard', locals: {count: 1}
end

get '/register' do
  haml :'users/register'
end

post '/register' do
  app.create_user params
  new_session app.fetch_user(params[:email])
  redirect '/'
end

get '/logout' do
  session_end!
  redirect '/login'
end

post '/login' do
  begin
    user = app.fetch_user(params[:email])
    new_session(user) if app.password_matches?(user, params[:password])
  rescue WrongPassword
    flash[:error] = 'Wrong password'
  rescue NoUserFound
    flash[:error] = 'No one with that email was found'
  ensure
    redirect '/'
  end
end

def new_session(user)
  session_start!
  session[:name] = user.email
  session[:user_id] = user.id
end
