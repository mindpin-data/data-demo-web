class LineChart extends Graph
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

    @svg = @draw_svg()

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = 'rgb(137, 189, 27)'
    @c2 = 'rgb(6, 129, 200)'
    @c3 = 'rgb(217, 6, 8)'
    @c4 = 'rgb(255, 222, 0)'
    @colors = [@c1, @c2, @c3, @c4]

    @xscale = d3.scaleLinear()
      .domain [0, 14]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 70]
      .range [@h, 0]

    @make_defs()

    @draw_axis()
    @draw_lines()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @draw_lines()

  make_def: (r, g, b, id)->
    lg = @svg_defs.append('linearGradient')
      .attr 'id', id
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '0%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.1)"

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.0)"


  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html
    @svg_defs = @svg.append('defs')

    @make_def 137, 189, 27, 'line-chart-linear1'
    @make_def 6, 129, 200, 'line-chart-linear2'
    @make_def 217, 6, 8,  'line-chart-linear3'
    @make_def 255, 222, 0,  'line-chart-linear4'


  draw_lines: ->
    @panel.remove() if @panel?
    @panel = @svg.append('g')
      .attr 'transform', "translate(30, 10)"

    line1 = d3.line()
      .x (d, idx)=> @xscale idx
      .y (d)=> @yscale d
      .curve(d3.curveCatmullRom.alpha(0.5))

    create_line = (data)=>
      d3.line()
        .x (d, idx)=>
          if idx == 0
            @xscale data.length - 1
          else if idx == 1
            @xscale 0
          else
            @xscale idx - 2

        .y (d, idx)=>
          @yscale d

    @panel.selectAll('path.pre-line').remove()
    @panel.selectAll('circle').remove()


    cidx = 0

    _curve = (data)=>
      if data? and data.length > 0
        color = @colors[cidx]
        fill = "url(#line-chart-linear#{cidx + 1})"
        cidx += 1

        arealine = create_line(data)

        _data = data.map (x)-> 0

        area = @panel.append 'path'
          .datum [0, 0].concat _data
          .attr 'class', 'pre-line'
          .attr 'd', arealine
          .style 'fill', fill

        area.datum [0, 0].concat data
          .transition()
          .duration 1000
          .attr 'd', arealine

        curve = @panel.append 'path'
          .datum _data
          .attr 'class', 'pre-line'
          .attr 'd', line1
          .style 'stroke', color
          .style 'fill', 'transparent'
          .style 'stroke-width', 2

        curve.datum data
          .transition()
          .duration 1000
          .attr 'd', line1

        for d, idx in _data
          circle = @panel.append 'circle'
            .attr 'cx', @xscale idx
            .attr 'cy', @yscale d
            .attr 'r', 4
            .attr 'fill', color

          circle
            .transition()
            .duration 1000
            .attr 'cy', @yscale data[idx]

    _curve @locality_1.data
    _curve @locality_2.data
    _curve @locality_3.data
    _curve @locality_4.data

  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', "translate(#{30}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y'
      .attr 'transform', "translate(#{30}, #{10})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
        .tickFormat (d, idx)->
          return "#{idx + 1}日"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 10, 20, 30, 40, 50, 60, 70])
    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart