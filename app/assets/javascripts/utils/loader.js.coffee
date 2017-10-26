jQuery ->
  # BaseTile.paper_init()
  return if not window.data_path

  jQuery.get window.data_path + "?#{Math.random()}"
    .success (res)->
      window.map_data = res
      BaseTile.paper_init()

      # 每 5s 重绘一次
      setInterval ->
        jQuery(document).trigger('data-map:next-draw')
      , 5 * 1000

      # 每 1min 重新加载数据一次
      setInterval ->
        jQuery.get window.data_path + "?#{Math.random()}"
          .success (res)-> window.map_data = res
      , 1000 * 60 * 1

      # 每 5min 定时刷新一次
      setTimeout =>
        # console.log('refresh')
        window.location.href = window.location.href
      , 1000 * 60 * 5