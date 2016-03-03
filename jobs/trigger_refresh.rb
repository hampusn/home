

SCHEDULER.in '20s' do
  puts 'refresh sent'
  send_event('trigger_refresh', {event: 'reload', dashboard: 'landscape'}, 'dashboards')
  send_event('trigger_refresh', {event: 'reload', dashboard: 'index'}, 'dashboards')  
end
