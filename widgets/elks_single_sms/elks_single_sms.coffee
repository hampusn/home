class Dashing.ElksSingleSms extends Dashing.Widget
  onData: (data) =>
    @set('from', 'Recieved from ' + data.from)
