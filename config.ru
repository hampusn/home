require 'dotenv'
# Load .env file which contains environment variables 
# Heroku handles this automagically but since I wan't to develop locally 
# and Dashing requires `dashing start` I can't use `heroku local`. Sad panda :(
Dotenv.load

require 'i18n'
require 'i18n/backend/fallbacks'

# Helper gem to pass ruby variables to dashboard for use in javascript
require 'gon-sinatra'

# The gem which handles the main logic
require 'dashing'

configure do
  set :auth_token, ENV['AUTH_TOKEN'] ||  'AUTH_TOKEN'
  set :default_dashboard, 'index'

  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
  I18n.enforce_available_locales = false

  set :default_locale, 'en'
  set :locale, ENV['LOCALE'] || settings.default_locale

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

before '/:dashboard' do
  if params[:dashboard] == 'index'
    
    gon.locale = settings.locale

    # Localization strings for widgets
    gon.widgets = {
      elks_single_sms: {
        from: I18n.t('widgets.elks_single_sms.from')
      }
    }
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

# Register Gon
Sinatra::register Gon::Sinatra
# Init
run Sinatra::Application