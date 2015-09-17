if window.Storage and window.JSON
  window.$storage = (key) ->
    set: (value) ->
      localStorage.setItem(key, JSON.stringify(value))
    get: ->
      item = localStorage.getItem(key)
      JSON.parse(item) if item