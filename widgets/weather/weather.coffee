class Dashing.Weather extends Dashing.I18nWidget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    if data?.now?.climacon
      # reset classes
      $('i.climacon').attr 'class', "climacon icon-background #{data.now.climacon}"
