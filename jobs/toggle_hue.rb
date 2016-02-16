require 'hue'
require 'json'

def new_hue_client
  client = nil
  err_msg = ''
  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale
  
  begin
    client = Hue::Client.new
  rescue Hue::NoBridgeFound => e
    err_msg = I18n.t('jobs.toggle_hue.errors.no_bridge_found')
  rescue StandardError => e
    err_msg = e.message
  end

  unless err_msg.empty?
    send_event('toggle_hue', {
      error: err_msg
    });  
  end

  client
end

def group_is_on?
  client = new_hue_client
  unless client.nil?
    group_is_on = true
    client.lights.each { |light|
      group_is_on = group_is_on && light.on?
    }
    group_is_on
  else
    false
  end
end

get '/hue/connectivity' do
  connectivity = !new_hue_client.nil?

  {:status => "success", :connectivity => connectivity}.to_json
end

get '/hue/state' do
  content_type :json

  if group_is_on?
    state = 'on'
  else
    state = 'off'
  end

  send_event('toggle_hue', {
    state: state
  });
  {:status => "success", :state => state}.to_json
end

post '/hue/state' do
  content_type :json

  client = new_hue_client
  unless client.nil?
    if params[:new_state] == 'on'
      client.lights.each { |light|
        light.on!
      }
    else
      client.lights.each { |light|
        light.off!
      }
    end
  end

  {:status => "success"}.to_json
end
