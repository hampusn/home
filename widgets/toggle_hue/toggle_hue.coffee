class Dashing.ToggleHue extends Dashing.ClickableWidget
  constructor: ->
    super

  @accessor 'state',
    get: -> @_state ? 'off'
    set: (key, value) -> @_state = value

  getState: ->
    $.get '/hue/state',
      (data) =>
        console.log(data);
        # json = JSON.parse data
        # @set 'state', json.switch

  setState: (newState) ->
    $.post '/hue/state',
      new_state: newState,
      (data) =>
        console.log(data);

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @set 'state', data.state

  onTap: (event) ->
    newState = if @get('state') == 'on' then 'off' else 'on'
    @setState(newState);
