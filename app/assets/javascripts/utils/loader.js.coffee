jQuery ->
  # BaseTile.paper_init()
  return if not window.data_path

  jQuery.get window.data_path + "?#{Math.random()}"
    .success (res)->
      window.map_data = res
      BaseTile.paper_init()

      setInterval ->
        jQuery(document).trigger('data-map:next-draw')
      , 5 * 1000

      setInterval ->
        jQuery.get window.data_path + "?#{Math.random()}"
          .success (res)-> window.map_data = res
      , 10 * 1000