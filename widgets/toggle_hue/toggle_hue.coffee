class Dashing.ToggleHue extends Dashing.ClickableWidget
  constructor: ->
    super
    @updateState();

  @accessor 'state',
    get: -> @_state ? 'off'
    set: (key, value) -> @_state = value

  updateState: ->
    $.get '/hue/state',
      (data) =>
        if data.status == 'success'
          @set 'state', data.state

  setState: (newState) ->
    $.post '/hue/state',
      new_state: newState,
      (data) =>
        @updateState();

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    @set 'state', data.state

  onTap: (event) ->
    newState = if @get('state') == 'on' then 'off' else 'on'
    @setState(newState);
