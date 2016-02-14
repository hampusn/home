require 'net/http'
require 'uri'
require 'json'
require 'time'

# URI to SMS cache endpoint
cache_uri = URI(ENV['ELKS_SMS_CACHE_URI'] || 'http://user:pass@localhost:5000/sms?channel=test-channel&n=5')

SCHEDULER.every '10s', :first_in => 0 do |job|
  # Setup i18n
  I18n.default_locale = settings.default_locale
  I18n.locale = settings.locale

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

    items = json_response
    first = items[0]

    items.each { |item|
      item['time'] = Time.parse(item['created_at'])

      metas = Hash.new;
      item['meta'].each do |meta|
        metas[meta['key']] = meta['value'];
      end
      item['meta'] = metas;

      item['from_formatted'] = sprintf I18n.t('jobs.elks_sms_cache.from'), item['meta']['from']
    } 

    send_event('elks_single_sms', {
      message: first['message'],
      from: first['meta']['from'],
      time: first['time']
    });

    send_event('elks_latest_sms', {
      items: items
    });
  end
end