class Dashing.ElksSingleSms extends Dashing.Widget
  onData: (data) =>
    time = moment(data.time).calendar()
    
    @set('time', time)
    @set('from', 'Recieved from ' + data.from)
