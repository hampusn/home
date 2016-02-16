class Dashing.I18nWidget extends Dashing.Widget
  constructor: ->
    super

  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      timestamp = new Date(updatedAt * 1000)
      hours = ("0" + timestamp.getHours()).slice(-2)
      minutes = ("0" + timestamp.getMinutes()).slice(-2)
      "#{hours}:#{minutes}"
