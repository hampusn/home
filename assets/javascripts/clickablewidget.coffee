class Dashing.ClickableWidget extends Dashing.Widget
  constructor: ->
    super
    $(@node).on 'click', (evt) => @handleClick evt
    $(@node).on 'touchstart', (evt) => @handleTouchStart evt
    $(@node).on 'touchmove', (evt) => @handleTouchMove evt
    $(@node).on 'touchend', (evt) => @handleTouchEnd evt
    $(@node).on 'tap', (evt) => @handleTap evt

  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      timestamp = new Date(updatedAt * 1000)
      hours = timestamp.getHours()
      minutes = ("0" + timestamp.getMinutes()).slice(-2)
      gon.widgets.i18n_widget.updated_at.replace("%h", hours).replace("%m", minutes)

  handleClick: (evt) ->
    @onClick evt

  handleTouchStart: (evt) ->
    evt.preventDefault()
    @onTouchStart evt

  handleTouchMove: (evt) ->
    @onTouchMove evt

  handleTouchEnd: (evt) ->
    @onTouchEnd evt
    @onClick evt

  handleTap: (evt) ->
    @onTap evt

  onClick: (evt) ->
    # override for click events

  onTouchStart: (evt) ->
    # override for touchstart events

  onTouchMove: (evt) ->
    # override for touchmove events

  onTouchEnd: (evt) ->
    # override for touchend events

  onTap: (evt) ->
    # override for tap events