require 'net/http'
require 'uri'
require 'json'
require 'time'

# URI to SMS cache endpoint
cache_uri = URI(ENV['ELKS_SINGLE_SMS_CACHE_URI'] || 'http://user:pass@localhost:5000/sms?channel=test-channel&n=1')

SCHEDULER.every '10s', :first_in => 0 do |job|
  # Create request
  req = Net::HTTP::Get.new(cache_uri)
  # Set Basic Auth from cache uri
  req.basic_auth cache_uri.user, cache_uri.password
  # Send request
  res = Net::HTTP.start(cache_uri.hostname, cache_uri.port) { |http|
    http.request(req)
  }

  if res && res.body
    json_response = JSON.parse(res.body)
    sms = json_response['items'][0]

    time = Time.parse(sms['created_at'])

    send_event('elks_single_sms', {
      message: sms['message'],
      from: sms['from'],
      to: sms['to'],
      time: time
    });
  end
end