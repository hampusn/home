# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  # Setup momentJS locale if locale exists
  if moment && gon.locale
    moment.locale(gon.locale)

  Dashing.widget_margins ||= [4, 4]
  Dashing.widget_base_dimensions ||= [292, 333]
  Dashing.numColumns ||= 2

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    grid = $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout

    grid.data('gridster').disable()
