require 'dotenv'
# Load .env file which contains environment variables 
# Heroku handles this automagically but since I wan't to develop locally 
# and Dashing requires `dashing start` I can't use `heroku local`. Sad panda :(
Dotenv.load

require 'dashing'

configure do
  set :auth_token, ENV['AUTH_TOKEN'] ||  'AUTH_TOKEN'
  set :default_dashboard, 'index'


  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application