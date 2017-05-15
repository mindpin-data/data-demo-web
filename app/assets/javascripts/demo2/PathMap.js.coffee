class PathMap extends Graph
  prepare_data: ->
    @localities = window.map_data.localities
    @materials = window.map_data.materials
    @colors = {}
    @materials.forEach (x)=>
      @colors[x.name] = x.color

    @scourges = window.map_data.scourges

  draw: ->
    @prepare_data()

    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'
    # @MAP_FILL_COLOR = '#0f2438'

    @svg = @draw_svg()
    @load_data()

  load_data: ->
    d3.json 'data/china.json?1', (error, _data)=>
      @features = _data.features

      @init()

      @idx = 0
      @current_product = @materials[0]
      @draw_map()

      jQuery(document).on 'data-map:next-draw', =>
        @prepare_data()
        @draw_next()

  draw_next: ->
    @idx += 1
    @idx = 0 if @idx == 3
    @current_product = @materials[@idx]

    @_draw_texts()
    @_draw_circle()

  init: ->
    # http://s.4ye.me/ziMnfK
    @projection = d3.geoMercator()
      .center [105, 28]
      .scale @width * 2.0
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    @layer_map = @svg.append 'g'
    @layer_circles = @svg.append 'g'
    @layer_icon = @svg.append 'g'

  draw_map: ->
    @_draw_map()
    @_draw_texts()
    @_draw_circle()
    @_draw_warning()

  _draw_texts: ->
    @texts.remove() if @texts?
    @texts = @layer_map.append 'g'

    _text = (color, text, y, opacity)=>
      panel = @texts.append 'g'
        .style 'transform', "translate(50px, #{@height - 150 + y}px)"
        .style 'opacity', opacity

      size = 24
      panel
        .append 'circle'
        .attr 'cx', 8
        .attr 'cy', 8
        .attr 'r', 16
        .attr 'fill', color

      panel
        .append 'text'
        .attr 'x', 36
        .attr 'y', size / 2 - 4
        .attr 'dy', '.33em'
        .text text
        .style 'font-size', size + 'px'
        .style 'fill', '#ffffff'

    top = 0
    @materials.forEach (x)=>
      _text x.color, "#{x.name}原产地", top, if @current_product.name == x.name then 1 else 0.3
      top += 50



  _draw_map: ->
    @areas.remove() if @areas?

    @areas = @layer_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 1
      .style 'fill', @MAP_FILL_COLOR

  _draw_circle: ->
    @points.remove() if @points?
    points = @points = @layer_map.append 'g'

    for d in @localities
      [x, y] = @projection [d.long, d.lat]

      points.append 'circle'
        .attr 'class', 'chandi'
        .attr 'cx', x
        .attr 'cy', y
        .attr 'r', d.amount
        .attr 'fill', => @colors[d.material]
        .style 'opacity', =>
          if d.material == @current_product.name then 1 else 0.1

  _draw_warning: ->
    @scourges.forEach (s)=>
      [x, y] = @projection [s.long, s.lat]
      new CityAnimate(@, x, y, '#ffffff', 8, "images/scourges/#{s.icon}-0.png", "#{s.name}：近期#{s.scourge}").run()


class CityAnimate
  constructor: (@map, @x, @y, @color, @width, @img, @text)->
    @layer_icon = @map.layer_icon
    @layer_circles = @map.layer_circles

  run: ->
    w = 60
    @layer_icon.append 'image'
      .attr 'xlink:href', @img
      .attr 'x', @x
      .attr 'y', @y
      .style 'transform', "translate(-#{w / 2}px, -#{w / 2}px)"
      .attr 'width', w
      .attr 'height', w

    size = 20
    @layer_icon.append 'text'
      .attr 'x', @x + 50
      .attr 'y', @y
      .attr 'dy', '.33em'
      .text @text
      .style 'font-size', size + 'px'
      .style 'fill', '#f66'

    @wave()


  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  wave: ->
    @circle_wave(0)
    @timer = setInterval =>
      @circle_wave(0)
    , 500

  stop: ->
    clearInterval @timer

  # 在指定的位置用指定的颜色显示扩散光圈
  circle_wave: (delay)->
    circle = @layer_circles.insert 'circle', '.map-point'
      .attr 'cx', @x
      .attr 'cy', @y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      .attr 'fill', 'transparent'

    jQuery({ r: 10, o: 1, w: @width }).delay(delay).animate({ r: 100, o: 0.6, w: 0 }
      {
        step: (now, fx)->
          if fx.prop == 'r'
            circle.attr 'r', now
          if fx.prop == 'o'
            circle.style 'opacity', now
          if fx.prop == 'w'
            circle.attr 'stroke-width', now

        duration: 2000
        easing: 'easeOutQuad'
        done: ->
          circle.remove()
      }
    )



BaseTile.register 'path-map', PathMap