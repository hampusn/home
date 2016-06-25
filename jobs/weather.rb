require 'net/http'
require 'uri'
require 'json'
require 'time'

weather_uri = URI(ENV['WEATHER_URI'] || '')

# SMHI API DOCS: http://opendata.smhi.se/apidocs/metfcst/parameters.html

 
SCHEDULER.every '10m', :first_in => 0 do |job|
  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

  # Create request
  req = Net::HTTP::Get.new(weather_uri)

  # Send request
  res = Net::HTTP.start(weather_uri.hostname, weather_uri.port) { |http|
    http.request(req)
  }

  if res && res.body
    weather_data = JSON.parse(res.body)

    timeseries = weather_data['timeSeries']

    closest = find_item_closest_to_date(timeseries, Time.now.utc.iso8601)

    send_event('weather', {
      now: weather_hash(closest)
    })
  end
end

def find_weather_param_value_by_name(parameters, name)
  p = parameters.find { |param| param["name"] == name }
  p['values'][0]
end

def weather_hash(item)
  temp          = find_weather_param_value_by_name(item['parameters'], 't')
  condition     = find_weather_param_value_by_name(item['parameters'], 'pcat')
  precipitation = find_weather_param_value_by_name(item['parameters'], 'pmax')

  {
    temp: "#{temp}&deg;C",
    condition: weather_category(condition),
    precipitation: precipitation,
    showPrecipitation: (condition >= 2 || condition <= 6),
    title: "Jönköping",
    climacon: climacon_class(condition),
    error: ""  
  }
end


def weather_category(pcat)
  case pcat.to_i
  when 0
    'Okänt väder' # no
  when 1
    'Snö' # snow
  when 2
    'Snöblandat regn' # snow and rain
  when 3
    'Regn' # rain
  when 4
    'Duggregn' # drizzle
  when 5
    'Isande regn' # freezing rain
  when 6
    'Isande duggregn' # freezing drizzle
  end
end


def find_item_closest_to_date(items, findDate)
  unless findDate.instance_of? Time
    findDate = Time.parse(findDate)
  end

  items.sort_by { |date|
    (Time.parse(date['validTime']) - findDate).abs
  }.first
end


def climacon_class(pcat)
  case pcat.to_i
  when 0
    'cloud' # no
  when 1
    'snow' # snow
  when 2
    'rain' # snow and rain
  when 3
    'rain' # rain
  when 4
    'drizzle' # drizzle
  when 5
    'rain' # freezing rain
  when 6
    'drizzle' # freezing drizzle
  end
end
