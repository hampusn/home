class Dashing.NewlyAddedShows extends Dashing.ClickableWidget
  constructor: ->
    super
    stored = $storage('newlyAddedShows').get();
    if !stored
      $storage('newlyAddedShows').set({
        "latestTime": "",
        "hasNewMessages": false
      })
    # Trigger onData with history data to get pretty dates through momemt.js
    lastData = Dashing.lastEvents[@id]
    if lastData?.items?
      @onData(lastData.items)

  momentItems: (items) =>
    if items?
      for item in items
        if item.meta.air_date?
          m = moment(item.meta.air_date, "YYYY-MM-DD")
          if m?.isValid
            item.meta.air_date = m.calendar(null, gon.widgets.newly_added_shows.formats)
      items

  onData: (data) =>
    if data?.items?
      @momentItems(data.items)
      
      stored = $storage('newlyAddedShows').get()

      if stored?.latestTime?
        current = new Date(stored.latestTime)
        latest = new Date(data.items[0].time)

        if latest > current
          stored.hasNewMessages = true
        
      if stored.hasNewMessages
        $(@node).addClass('notice')
      
      stored.latestTime = data.items[0].time
      $storage('newlyAddedShows').set(stored)

  onTap: (event) ->
    stored = $storage('newlyAddedShows').get()
    stored.hasNewMessages = false
    $storage('newlyAddedShows').set(stored)
    $(@node).removeClass('notice')
