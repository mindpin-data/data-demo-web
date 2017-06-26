class LineChart extends Graph
  prepare_data: ->
    countries = window.map_data.countries

    @aidx = 0 if not @aidx?
    @aidx += 1
    @aidx = 0 if @aidx == countries.length
    @current_area = countries[@aidx]

    @data0 = @current_area.now
    @data1 = @current_area.history

  draw: ->
    @prepare_data()

    @svg = @draw_svg()

    @h = @height - 40
    @w = @width - 60
    @gap = (@w - 30) / 5

    @c1 = 'rgb(205, 255, 65)'
    @c2 = 'rgb(60, 180, 236)'

    @xscale = d3.scaleLinear()
      .domain [0, 5]
      .range [0, @w]

    @yscale = d3.scaleLinear()
      .domain [0, 200]
      .range [@h, 0]

    @make_defs()

    @draw_axis()
    @draw_lines()

    jQuery(document).on 'data-map:next-draw', =>
      @next_draw()

  next_draw: ->
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
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.2)"

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', "rgba(#{r}, #{g}, #{b}, 0.0)"

  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html
    @svg_defs = @svg.append('defs')

    @make_def 205, 255, 65, 'line-chart-linear1'
    @make_def 60, 180, 236, 'line-chart-linear2'


  draw_lines: ->
    if not @panel?
      @panel = @svg.append('g')
        .attr 'transform', "translate(42, 10)"

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

    _draw = (arealine, line, data, color, fill)=>
      _data = data.map (x)-> 0

      duration = 1000

      # 渐变色区域
      area = @panel.append 'path'
        .datum [0, 0].concat _data
        .attr 'class', 'pre-line'
        .attr 'd', arealine
        .style 'fill', fill

      area
        .datum [0, 0].concat data
        .transition()
        .attr 'd', arealine
        .duration duration
        .ease d3.easeCubicOut


      # 折线区域
      curve = @panel.append 'path'
        .datum _data
        .attr 'class', 'pre-line'
        .attr 'd', line
        .style 'stroke', color
        .style 'fill', 'transparent'
        .style 'stroke-width', 2

      curve
        .datum data
        .transition()
        .attr 'd', line
        .duration duration
        .ease d3.easeCubicOut

      # 折线上的点
      _data.forEach (d, idx)=>
        circle = @panel.append 'circle'
          .attr 'cx', @xscale idx
          .attr 'cy', @yscale d
          .attr 'r', 4
          .attr 'fill', color

        circle
          .transition()
          .attr 'cy', @yscale data[idx]
          .duration duration
          .ease d3.easeCubicOut

    _draw create_line(@data0), line1, @data0, @c1, 'url(#line-chart-linear1)'
    _draw create_line(@data1), line1, @data1, @c2, 'url(#line-chart-linear2)'


  draw_axis: ->
    axisx = @svg.append('g')
      .attr 'class', 'axis axis-x white1'
      .attr 'transform', "translate(#{42}, #{10 + @h})"

    axisy = @svg.append('g')
      .attr 'class', 'axis axis-y white1'
      .attr 'transform', "translate(#{42}, #{10})"

    axisx.call(
      d3.axisBottom(@xscale)
        .tickValues([0, 1, 2, 3, 4, 5])
        .tickFormat (d, idx)-> 
          return '' if idx == 0
          return "#{idx * 2}"
    )

    axisy.call(
      d3.axisLeft(@yscale)
        .tickValues([0, 50, 100, 150, 200])
    ).selectAll '.tick line'
      .attr 'x1', @w



BaseTile.register 'line-chart', LineChart