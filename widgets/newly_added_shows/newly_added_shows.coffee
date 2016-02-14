class Dashing.NewlyAddedShows extends Dashing.ClickableWidget
  constructor: ->
    super
    stored = $storage('newlyAddedShows').get();
    if !stored
      $storage('newlyAddedShows').set({
        "latestTime": "",
        "hasNewMessages": false
      })

  onData: (data) =>
    for item in data.items
      item.meta.air_date = moment(item.meta.air_date).calendar()
      
    stored = $storage('newlyAddedShows').get()

    if !!stored.latestTime
      current = new Date(stored.latestTime)
      latest = new Date(data.items[0].time)

      if latest > current
        stored.hasNewMessages = true
      
    if stored.hasNewMessages
      $(@node).addClass('notice')
    
    stored.latestTime = data.items[0].time
    $storage('newlyAddedShows').set(stored);

  onTap: (event) ->
    stored = $storage('newlyAddedShows').get();
    stored.hasNewMessages = false
    $storage('newlyAddedShows').set(stored);
    $(@node).removeClass('notice')
