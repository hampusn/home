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

    stored = $storage('elksLatestSms').get();

    # ...

    $storage('elksLatestSms').set(stored);
