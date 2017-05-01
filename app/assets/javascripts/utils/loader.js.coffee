jQuery ->
  # BaseTile.paper_init()
  jQuery.get window.data_path
    .success (res)->
      window.map_data = res
      BaseTile.paper_init()

      setInterval ->
        jQuery(document).trigger('data-map:next-draw')
      , 5 * 1000

      setInterval ->
        jQuery.get window.data_path
          .success (res)-> window.map_data = res
      , 60 * 1000