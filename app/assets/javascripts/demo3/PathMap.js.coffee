LOGO_PATH = "M461.331,294.545c-11.119-34.221-56.452-50.278-102.081-36.623c-1.106-47.624-30.406-85.779-66.393-85.779c-35.987,0-65.286,38.155-66.393,85.779c-45.629-13.655-90.961,2.403-102.08,36.624c-11.12,34.226,16.114,73.882,61.065,89.65c-27.087,39.176-25.823,87.252,3.286,108.401c29.114,21.152,75.234,7.491,104.123-30.387c28.888,37.878,75.008,51.538,104.122,30.387c29.11-21.149,30.373-69.226,3.286-108.402C445.218,368.426,472.45,328.771,461.331,294.545z"


# 循环执行
floop = (func, duration)->
  func()
  setInterval ->
    func()
  , duration

# 从数组中随机取一项
rand_item_of = (arr)->
  arr[Math.floor(arr.length * Math.random())]

class MainMap extends Graph
  prepare_data: ->
    @cn_cities = window.map_data.cn_cities
    @world_cities = window.map_data.world_cities

    # 最大数量
    @max_number = 0
    @cn_cities.forEach (x)=>
      @max_number = Math.max(x.amount, @max_number)

  draw: ->
    @prepare_data()

    @MAP_STROKE_COLOR = '#021225'
    @MAP_FILL_COLOR = '#323c48'

    @svg = @draw_svg()
    @load_data()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @next_draw()

  next_draw: ->
    @random_city()

  load_data: ->
    d3.json 'data/world-countries.json?1', (error, _data)=>
      @features = _data.features

      @draw_map()

      @draw_heatmap()
      @svg1 = @draw_svg()
        .style 'position', 'absolute'
        .style 'left', '0'
        .style 'top', '0'

      @random_city()

  draw_map: ->
    # http://s.4ye.me/ziMnfK

    @map_scale = 0.14
    # @projection = d3.geoMercator()
    @projection = d3.geoEquirectangular()
      .center [8, 8]
      .scale @width * @map_scale
      .translate [@width / 2, @height / 2]

    @path = d3.geoPath @projection

    @g_map = @svg.append 'g'

    @_draw_map()

  _draw_map: ->
    @g_map.selectAll('.country').remove()

    mfc = [
      # '#f8e8b7'
      # '#d6e7ba'
      # '#f9d8e9'
      # '#fbfb99'
      # '#e8ebfa'
      '#c69a5d'
      '#a5c18e'
      '#c7b7b7'
      '#dee47e'
      '#b282b3'

      '#5d875d'
      '#568d85'
      '#6789bb'
    ]

    countries = @g_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 1
      .style 'fill', (d, idx)=>
        # 橙
        return mfc[0] if d.id == 'RUS'
        return mfc[0] if d.id == 'TCD'
        return mfc[0] if d.id == 'BOL'
        return mfc[0] if d.id == 'MOZ'
        return mfc[0] if d.id == 'BFA'
        return mfc[6] if d.id == 'ETH'
        return mfc[6] if d.id == 'UGA'

        # 绿
        return mfc[1] if d.id == 'MEX'
        return mfc[1] if d.id == 'KAZ'
        return mfc[1] if d.id == 'BWA'
        return mfc[1] if d.id == 'SUR'
        return mfc[1] if d.id == 'UKR'
        return mfc[3] if d.id == 'MMR'
        return mfc[1] if d.id == 'JPN'
        return mfc[1] if d.id == 'MRT'

        # 红
        return mfc[2] if d.id == 'CHN'
        return mfc[2] if d.id == 'USA'
        return mfc[2] if d.id == 'BFA'
        return mfc[2] if d.id == 'HUN'
        return mfc[2] if d.id == 'ITA'
        return mfc[2] if d.id == 'AGO'

        # 黄
        return mfc[3] if d.id == 'CHL'
        return mfc[3] if d.id == 'CAN'
        return mfc[3] if d.id == 'MNG'
        return mfc[3] if d.id == 'MLI'
        return mfc[3] if d.id == 'TKM'
        return mfc[3] if d.id == 'SAU'
        return mfc[3] if d.id == 'LBY'
        return mfc[3] if d.id == 'IDN'
        return mfc[3] if d.id == 'ZMB'


        # 紫
        return mfc[4] if d.id == 'ZAF'
        return mfc[4] if d.id == 'GUY'
        return mfc[4] if d.id == 'TUN'
        return mfc[4] if d.id == 'BGR'
        return mfc[4] if d.id == 'THA'
        return mfc[4] if d.id == 'CMR'

        return mfc[5] if d.id == 'SDN'
        return mfc[6] if d.id == 'IRN'

        return mfc[7] if d.id == 'CAF'
        mfc[idx % mfc.length]


  draw_heatmap: ->
    heatmapInstance = h337.create({
      # only container is required, the rest will be defaults
      container: jQuery('#heatmap')[0]
      radius: 16
      gradient:
        '0.0': '#ffffff'
        '0.3': '#00ffff'
        '1.0': '#ffffff'
    })

    cities = [].concat(@cn_cities).concat(@world_cities)
    points = cities.map (c)=>
      [x, y] = @projection [c.long, c.lat]

      {
        x: ~~x
        y: ~~y
        value: c.amount
      }

    data = {
      max: @max_number
      data: points
    }

    # console.log points

    heatmapInstance.setData(data)

  random_city: ->
    # @_r @cn_cities, '#cff1ae'
    # @_r @cn_cities, '#cff1ae'
    # @_r @world_cities, '#f1c4ae'
    # @_r @world_cities, '#f1c4ae'

    @_r @cn_cities, '#ff283b', true
    # @_r @cn_cities, '#ff283b', true
    @_r @world_cities, '#ff283b', false
    # @_r @world_cities, '#ff283b', false

    setTimeout =>
      # @_r @cn_cities, '#cff1ae'
      # @_r @cn_cities, '#cff1ae'
      # @_r @world_cities, '#f1c4ae'
      # @_r @world_cities, '#f1c4ae'

      @_r @cn_cities, '#ff283b', true
      # @_r @cn_cities, '#ff283b', true
      @_r @world_cities, '#ff283b', false
      # @_r @world_cities, '#ff283b', false
    , 2500

  _r: (arr, color, is_china)->
    p = rand_item_of arr
    [x, y] = @projection [p.long, p.lat]
    new CityAnimate(this, x, y, color, 8, is_china).run()


class CityAnimate
  constructor: (@map, @x, @y, @color, @width, @is_china)->
    @g_map = @map.svg1

  run: ->
    @flight_animate()

  # 飞机飞行动画
  flight_animate: ->
    [@gyx, @gyy] = @map.projection [106.4, 26.3]

    @draw_plane()
    @draw_route()
    @fly()

  # 在贵阳画一个小飞机
  draw_plane: ->
    @plane = @g_map.append 'path'
      .attr 'class', 'plane'
      .attr 'd', LOGO_PATH
      .attr 'fill', '#ff283b'

  # 画贵阳到收货地的航线
  draw_route: ->
    @route = @g_map.append 'path'
      .attr 'd', "M#{@gyx} #{@gyy} L#{@x} #{@y}"
      .style 'stroke', 'transparent'

  # 飞行
  fly: ->
    path = @route.node()
    l = path.getTotalLength()

    dx = @x - @gyx
    dy = @y - @gyy

    center_xoff = 586
    center_yoff = 696

    scale = 0.08
    xoff = center_xoff * scale * 0.5
    yoff = center_yoff * scale * 0.5

    count = 0
    jQuery({ t: 0 }).animate({ t: 1 }
      {
        step: (now, fx)=>
          p = path.getPointAtLength(now * l)

          count += 1
          if count % 8 == 0
            @route_circle_wave(p.x, p.y)
          
          @plane
            .attr 'transform', "translate(#{p.x - xoff}, #{p.y - yoff}) scale(#{scale})"

        duration: Math.sqrt(l) * 150
        easing: 'linear'
        done: =>
          @route.remove()
          @three_paths_wave()
          jQuery(document).trigger('data-map:number-raise', @is_china)

          jQuery({ o: 1 }).animate({ o: 0 }
            {
              step: (now, fx)=>
                @plane
                  .style 'opacity', now
              duration: 1000
              done: =>
                @plane.remove()
            }
          )
      }
    )

  # 在指定的位置用指定的颜色显示扩散光圈
  route_circle_wave: (x, y)->
    circle = @g_map.insert 'circle', '.plane'
      .attr 'cx', x
      .attr 'cy', y
      .attr 'stroke', @color
      .attr 'stroke-width', @width
      # .attr 'fill', 'transparent'
      .attr 'fill', @color

    jQuery({ r: 0, o: 0.9 }).delay(100).animate({ r: 5, o: 0 }
      {
        step: (now, fx)->
          if fx.prop == 'r'
            circle.attr 'r', now
          if fx.prop == 'o'
            circle.style 'opacity', now

        duration: 2000
        easing: 'easeOutQuad'
        done: =>
          circle.remove()
      }
    )



  # 在指定的位置用指定的颜色显示三个依次扩散的光圈
  three_paths_wave: ->
    @path_wave(0)
    @path_wave(500)
    @path_wave(1000)

  # 在指定的位置用指定的颜色显示扩散光圈
  path_wave: (delay)->
    center_xoff = 586
    center_yoff = 696

    scale = 0.1
    x = @x - center_xoff * scale * 0.5
    y = @y - center_yoff * scale * 0.5

    path = @g_map.append 'path'
      .attr 'd', LOGO_PATH
      .attr 'stroke', @color
      .attr 'stroke-width', 20
      .attr 'fill', 'transparent'
      .attr 'transform', "translate(#{x}, #{y}) scale(#{scale})"

    jQuery({ scale: 0.1, o: 1}).delay(delay).animate({ scale: 0.2, o: 0}
      {
        step: (now, fx)=>
          if fx.prop == 'scale'
            scale = now
            x = @x - center_xoff * scale * 0.5
            y = @y - center_yoff * scale * 0.5

            path.attr 'transform', "translate(#{x}, #{y}) scale(#{scale})"

          if fx.prop == 'o'
            path.style 'opacity', now

        duration: 2000
        easing: 'easeOutQuad'
        done: ->
          path.remove()
      }
    )



BaseTile.register 'main-map', MainMap