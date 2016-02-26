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

  settings = $('.gridster').data('layout')
  w = $(window).width()
  h = $(window).height()

  widgetWidth = (w - (settings.cols * settings.margin.x * 2)) / settings.cols
  widgetHeight = (h - (settings.rows * settings.margin.y * 2)) / settings.rows

  widgetWidth = Math.floor(widgetWidth)
  widgetHeight = Math.floor(widgetHeight)

  Dashing.widget_margins ||= [settings.margin.x, settings.margin.y]
  Dashing.widget_base_dimensions ||= [widgetWidth, widgetHeight]
  Dashing.numColumns ||= settings.cols

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    grid = $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout

    grid.data('gridster').disable()
