class LineChart extends Graph
  prepare_data: ->
    @data0 = window.map_data.now
    @data1 = window.map_data.forecast
    @data2 = window.map_data.history

  draw: ->
    @prepare_data()


    @svg = @draw_svg()
    @make_defs()

    @h = @height - 60
    @w = @width - 300
    @gap = (@w - 30) / 5

    @c1 = '#00ff18'
    @c2 = '#fbfb99'
    @c3 = '#ffac5a'

    @xscale = d3.scaleLinear()
      .domain [0, 11]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 100]
      .range [@h, 0]

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
      .attr 'x2', '10%'
      .attr 'y2', '100%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.9)"

    lg.append('stop')
      .attr 'offset', '50%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.2)"

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.0)"


  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html
    @svg_defs = @svg.append('defs')

    @make_def 0, 255, 24, 'line-chart-linear1'
    @make_def 251, 251, 153, 'line-chart-linear2'
    @make_def 255, 172, 90,  'line-chart-linear3'

  draw_lines: ->
    @panel.remove() if @panel?

    @panel = @svg.append('g')
      .attr 'transform', "translate(250, 20)"

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

    _draw = (data, color, fill, dasharray)=>
      # _data = data.map (x)-> 0
      _data = data

      arealine = create_line(_data)

      area = @panel.append 'path'
        .datum [0, 0].concat _data
        .attr 'class', 'pre-line'
        .attr 'd', arealine
        .style 'fill', fill

      curve = @panel.append 'path'
        .datum _data
        .attr 'class', 'pre-line'
        .attr 'd', line1
        .style 'stroke', color
        .style 'fill', 'transparent'
        .style 'stroke-width', 6
        .style 'stroke-dasharray', dasharray
        .style 'stroke-linecap', 'round'

      # curve.datum data
      #   .transition()
      #   .duration 1000
      #   .attr 'd', line1


      _data.forEach (d, idx)=>
        c = @panel.append 'circle'
          .attr 'cx', @xscale idx
          .attr 'cy', @yscale d
          .attr 'r', 10
          .attr 'fill', color

        c
          .transition()
          .duration 1000
          .attr 'cy', @yscale data[idx]


    _draw @data0, @c1, "url(#line-chart-linear1)"
    _draw @data1, @c2, "url(#line-chart-linear2)" #, '5 5'
    _draw @data2, @c3, "url(#line-chart-linear3)"


  draw_axis: ->
    offx = 250
    offy = 20

    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x white'
      .attr 'transform', "translate(#{offx}, #{offy + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y white'
      .attr 'transform', "translate(#{offx}, #{offy})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
        .tickFormat (d, idx)->
          return "#{idx + 1}月"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 20, 40, 60, 80, 100])
        .tickFormat (d, idx)->
          return '1,000,000,000' if d == 100
          return '0' if d == 0
          return "#{d}0,000,000"

    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart