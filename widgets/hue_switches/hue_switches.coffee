class Dashing.HueSwitches extends Dashing.ClickableWidget
  constructor: ->
    super
    @checkStatus()
    # @registerBridge()

  @accessor 'state',
    get: -> @_state ? 'disconnected'
    set: (key, value) -> @_state = value

  @accessor 'connectivity',
    get: -> @_connectivity ? false
    set: (key, value) -> @_connectivity = value

  registerBridge: ->
    $.post '/hue-switches/register'

  checkStatus: ->
    $.post '/hue-switches/status'

  onData: (data) ->
    if data?.connectivity?
      @set 'connectivity', data.connectivity

    console.log(data)

  onTap: (event) ->
    if @get 'connectivity' == false
      $.post '/hue-switches/register'
    else
      $.post '/hue-switches/toggle'
