require 'net/http'
require 'uri'
require 'json'
require 'time'

# URI to SMS cache endpoint
cache_uri = URI(ENV['NEWLY_ADDED_SHOWS_CACHE_URI'] || 'http://user:pass@localhost:5000/sms?channel=test-channel&n=5')
limit_num = 10

SCHEDULER.every '5m', :first_in => '5s' do |job|
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

    # Filter out items where message starts with "Found ".
    items = items.select do |item|
      !item['message'].start_with?('Found ')
    end

    # Slice out the first num items.
    items = items.take(limit_num)

    items.each do |item|
      item['time'] = Time.parse(item['created_at'])

      metas = Hash.new;
      item['meta'].each do |meta|
        metas[meta['key']] = meta['value'];
      end
      item['meta'] = metas;

      if item['meta']['notifier'] == 'couchpotato'
        if item['message'].start_with?('Downloaded ')
          item['message'].slice! 'Downloaded '
        end
        item['meta']['movie'] = I18n.t('jobs.newly_added_shows.movie')
      else
        item['message'] = item['meta']['show']
      end

      item['meta']['season_formatted'] = sprintf I18n.t('jobs.newly_added_shows.season'), item['meta']['season']
      item['meta']['episode_formatted'] = sprintf I18n.t('jobs.newly_added_shows.episode'), item['meta']['episode']
    end

    send_event('newly_added_shows', {
      items: items
    });
  end
end
