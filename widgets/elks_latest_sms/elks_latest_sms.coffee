class Dashing.ElksLatestSms extends Dashing.ClickableWidget
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
        stored.hasNewMessages = true
      
    if stored.hasNewMessages
      $(@node).addClass('notice')
    
    stored.latestTime = data.items[0].time
    $storage('elksLatestSms').set(stored);

  onTap: (event) ->
    stored = $storage('elksLatestSms').get();
    stored.hasNewMessages = false
    $storage('elksLatestSms').set(stored);
    $(@node).removeClass('notice')
