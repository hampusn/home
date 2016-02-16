class Dashing.ToggleHue extends Dashing.ClickableWidget
  constructor: ->
    super
    @updateState();

  @accessor 'state',
    get: -> @_state ? 'off'
    set: (key, value) -> @_state = value

  @accessor 'connectivity',
    get: -> @_connectivity ? false
    set: (key, value) -> @_connectivity = value

  checkConnectivity: ->
    $.get '/hue/connectivity',
      (data) =>
        if data.status == 'success'
          @set 'connectivity', data.connectivity
          $(@node).toggleClass('no-connectivity', !data.connectivity)

  updateState: ->
    $.get '/hue/state',
      (data) =>
        if data.status == 'success'
          @set 'state', data.state

  setState: (newState) ->
    $.post '/hue/state',
      new_state: newState,
      (data) =>
        @updateState()

  ready: ->
    # This is fired when the widget is done being rendered
    @checkConnectivity()

  onData: (data) ->
    if data.state
      @set 'state', data.state

    if data.error
      @set 'status', data.error
      $(@node).addClass('no-connectivity')

  onTap: (event) ->
    newState = if @get('state') == 'on' then 'off' else 'on'
    @setState(newState)
