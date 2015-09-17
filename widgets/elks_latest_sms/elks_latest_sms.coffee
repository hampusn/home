class Dashing.ElksLatestSms extends Dashing.Widget
  constructor: ->
    super
    stored = $storage('elksLatestSms').get();
    if !stored
      $storage('elksLatestSms').set({
        "latestTime": "",
        "hasNewMessages": false
      })

  onData: (data) =>
    for item in data.items
      item.time_formatted = moment(item.time).calendar()

    stored = $storage('elksLatestSms').get()

    if !!stored.latestTime
      current = new Date(stored.latestTime)
      latest = new Date(data.items[0].time)

      if latest > current
        console.log('NEW MESSAGES');
        stored.hasNewMessages = true
      
    if stored.hasNewMessages
      console.log('SHOW ALERT')
    
    stored.latestTime = data.items[0].time
    $storage('elksLatestSms').set(stored);
