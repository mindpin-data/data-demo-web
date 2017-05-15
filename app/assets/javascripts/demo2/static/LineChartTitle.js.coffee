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
      .text "#{@current_product.name}采购价格趋势（单位：万元 / 吨）"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    left = 32
    y0 = @height / 2 - 7 + 30
    y1 = @height / 2 + 30
    idx = 0

    draw_locality = (locality)=>
      if locality.data? and locality.data.length > 0
        @texts
          .append 'rect'
          .attr 'x', left
          .attr 'y', y0
          .attr 'width', 30
          .attr 'height', 15
          .style 'fill', @colors[idx]

        @texts
          .append 'text'
          .attr 'x', left + 37
          .attr 'y', y1
          .attr 'dy', '.33em'
          .text locality.name
          .style 'font-size', size * 0.8 + 'px'
          .style 'fill', '#ffffff'

        left += 120
        idx += 1

    draw_locality @locality_1
    draw_locality @locality_2
    draw_locality @locality_3
    draw_locality @locality_4


    # @texts
    #   .append 'rect'
    #   .attr 'x', 390 - 180
    #   .attr 'y', @height / 2 - 7 + 30
    #   .attr 'width', 30
    #   .attr 'height', 15
    #   .style 'fill', @c2

    # @texts
    #   .append 'text'
    #   .attr 'x', 430 - 180
    #   .attr 'y', @height / 2 + 30
    #   .attr 'dy', '.33em'
    #   .text '上一年同期价'
    #   .style 'font-size', size + 'px'
    #   .style 'fill', '#ffffff'

    # @texts
    #   .append 'rect'
    #   .attr 'x', 390
    #   .attr 'y', @height / 2 - 7 + 30
    #   .attr 'width', 30
    #   .attr 'height', 15
    #   .style 'fill', @c3

    # @texts
    #   .append 'text'
    #   .attr 'x', 430
    #   .attr 'y', @height / 2 + 30
    #   .attr 'dy', '.33em'
    #   .text '政府指导价'
    #   .style 'font-size', size + 'px'
    #   .style 'fill', '#ffffff'

BaseTile.register 'line-chart-title', LineChartTitle