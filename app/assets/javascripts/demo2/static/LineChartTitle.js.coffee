class LineChartTitle extends Graph
  prepare_data: ->
    @materials = window.map_data.materials

    @idx = -1 if not @idx?
    @idx += 1
    @idx = 0 if @idx == @materials.length

    @current_product = @materials[@idx]

    @locality_1 = {name: @current_product.locality_1, data: @current_product.locality_1_data}
    @locality_2 = {name: @current_product.locality_2, data: @current_product.locality_2_data}
    @locality_3 = {name: @current_product.locality_3, data: @current_product.locality_3_data}
    @locality_4 = {name: @current_product.locality_4, data: @current_product.locality_4_data}

  draw: ->
    @prepare_data()

    @c1 = 'rgb(137, 189, 27)'
    @c2 = 'rgb(6, 129, 200)'
    @c3 = 'rgb(217, 6, 8)'
    @c4 = 'rgb(255, 222, 0)'
    @colors = [@c1, @c2, @c3, @c4]

    @svg = @draw_svg()
    @draw_texts()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @draw_texts()

  draw_texts: ->
    @texts.remove() if @texts?

    @texts = @svg.append('g')
      .style 'transform', 'translate(0px, 0px)'

    size = 20
    @texts
      .append 'text'
      .attr 'x', 10
      .attr 'y', @height / 2 - 10
      .attr 'dy', '.33em'
      .text "#{@current_product.name}采购价格年度趋势（单位：万元 / 吨）"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    left = 32
    y1 = @height / 2 + 25
    y0 = y1 - 7
    idx = 0

    draw_locality = (locality)=>
      if locality.data? and locality.data.length > 0
        @texts
          .append 'rect'
          .attr 'x', left
          .attr 'y', y0
          .attr 'width', 24
          .attr 'height', 12
          .style 'fill', @colors[idx]

        sz = size * 0.8
        @texts
          .append 'text'
          .attr 'x', left + 24 + 5
          .attr 'y', y1
          .attr 'dy', '.33em'
          .text locality.name
          .style 'font-size', sz + 'px'
          .style 'fill', '#ffffff'

        left += 24 + sz * 5.5
        idx += 1

    draw_locality @locality_1
    draw_locality @locality_2
    draw_locality @locality_3
    draw_locality @locality_4


BaseTile.register 'line-chart-title', LineChartTitle