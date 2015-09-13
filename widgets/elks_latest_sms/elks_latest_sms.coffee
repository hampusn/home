class Dashing.ElksLatestSms extends Dashing.Widget
  onData: (data) =>
    for item in data.items
      item.time = moment(item.time).calendar()
      item.from = gon.widgets.elks_single_sms.from.replace('%phone_number', item.from)
