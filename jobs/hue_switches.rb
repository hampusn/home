require 'huey'
require 'json'
require 'uri'

# Setup Huey
Huey.configure do |config|
  uri = URI(ENV['HUE_BRIDGE_URI'] || '')

  config.hue_ip = uri.host
  config.hue_port = uri.port || 80
end


SCHEDULER.every '5s' do |job|
  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

  result = {
    status: I18n.t('jobs.hue_switches.status.bridge_connection'),
    connectivity: true
  }

  begin
    Huey::Bulb.all.reload
    result[:state] = state_text_on(group_state)
  rescue Huey::Errors::Error => e
    result = {
      status: e.message,
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  rescue StandardError => e
    result = {
      status: I18n.t('jobs.hue_switches.status.generic_error'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  end

  if result[:connectivity]
    send_event('hue_switches', result)
  end
end


post '/hue-switches/register' do
  content_type :json

  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

  result = {
    status: I18n.t('jobs.hue_switches.status.bridge_connection'),
    state: I18n.t('jobs.hue_switches.state.turn_off'),
    connectivity: true
  }

  begin
    Huey::Request.register
  rescue Huey::Errors::PressLinkButton => e
    result = {
      status: I18n.t('jobs.hue_switches.status.press_link_button'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  rescue Huey::Errors::CouldNotFindHue => e
    result = {
      status: I18n.t('jobs.hue_switches.status.no_bridge_found'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  rescue StandardError => e
    result = {
      status: I18n.t('jobs.hue_switches.status.generic_error'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  end

  send_event('hue_switches', result);
  {status: "success"}.to_json
end


post '/hue-switches/status' do
  content_type :json

  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

  result = {
    status: I18n.t('jobs.hue_switches.status.bridge_connection'),
    connectivity: true
  }

  begin
    bulbs = Huey::Bulb.all.reload
    result[:num_bulbs] = bulbs.length
    result[:state] = state_text_on(group_state)
  rescue Huey::Errors::Error => e
    result = {
      status: e.message,
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  rescue StandardError => e
    result = {
      status: I18n.t('jobs.hue_switches.status.generic_error'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  end

  send_event('hue_switches', result)
  {status: "success"}.to_json
end


post '/hue-switches/toggle' do
  content_type :json

  begin
    Huey::Bulb.all.on = !group_state
    Huey::Bulb.all.save
    result = {
      state: state_text_on(group_state)
    }
  rescue Huey::Errors::Error => e
    I18n.default_locale = settings.default_locale
    I18n.locale = settings.locale

    result = {
      status: e.message,
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  rescue StandardError => e
    result = {
      status: I18n.t('jobs.hue_switches.status.generic_error'),
      state: I18n.t('jobs.hue_switches.state.disconnected'),
      connectivity: false
    }
  end

  send_event('hue_switches', result);
  {status: "success"}.to_json
end


def group_state
  Huey::Bulb.all.length > 0 && Huey::Bulb.all.on.all? && Huey::Bulb.find(1).on
end


def state_text_on(state)
  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

  if state
    state_text = I18n.t('jobs.hue_switches.state.turn_off')
  else
    state_text = I18n.t('jobs.hue_switches.state.turn_on')
  end
  state_text
end
