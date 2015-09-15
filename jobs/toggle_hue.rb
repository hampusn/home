require 'hue'
require 'json'

def group_is_on?
  client = Hue::Client.new
  group_is_on = true
  client.lights.each { |light|
    group_is_on = group_is_on && light.on?
  }
  group_is_on
end

get '/hue/state' do
  content_type :json

  if group_is_on?
    state = 'on'
  else
    state = 'off'
  end

  {:status => "success", :state => state}.to_json
end

post '/hue/state' do
  content_type :json

  client = Hue::Client.new
  if params[:new_state] == 'on'
    client.lights.each { |light|
      light.on!
    }
  else
    client.lights.each { |light|
      light.off!
    }
  end

  {:status => "success"}.to_json
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
  if group_is_on?
    state = 'on'
  else
    state = 'off'
  end

  send_event('toggle_hue', {
    state: state
  });
end