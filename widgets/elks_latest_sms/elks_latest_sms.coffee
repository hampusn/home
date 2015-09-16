class Dashing.ElksLatestSms extends Dashing.Widget
  onData: (data) =>
    for item in data.items
      item.time_formatted = moment(item.time).calendar()
