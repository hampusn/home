require 'net/http'
require 'uri'

# URI to SMS cache endpoint
cache_uri = URI.parse(ENV['ELKS_SINGLE_SMS_CACHE_URI'] || 'http://user:pass@localhost:5000/sms?channel=test-channel')


SCHEDULER.every '10s', :first_in => 0 do |job|
  response = Net::HTTP.get(cache_uri)

  puts response

#  send_event('weather', { :temp => "#{weather_data['temp']}&deg;#{format.upcase}",
 #                         :condition => weather_data['text'],
  #                        :title => "#{weather_location['city']}",
   #                       :climacon => climacon_class(weather_data['code'])})
end