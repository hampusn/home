class Dashing.ElksSingleSms extends Dashing.Widget
  onData: (data) =>
    time = moment(data.time).calendar()
    from = gon.widgets.elks_single_sms.from.replace('%phone_number', data.from)


    @set('time', time)
    @set('from', from)
