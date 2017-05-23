LOGO_PATH = "M461.331,294.545c-11.119-34.221-56.452-50.278-102.081-36.623c-1.106-47.624-30.406-85.779-66.393-85.779c-35.987,0-65.286,38.155-66.393,85.779c-45.629-13.655-90.961,2.403-102.08,36.624c-11.12,34.226,16.114,73.882,61.065,89.65c-27.087,39.176-25.823,87.252,3.286,108.401c29.114,21.152,75.234,7.491,104.123-30.387c28.888,37.878,75.008,51.538,104.122,30.387c29.11-21.149,30.373-69.226,3.286-108.402C445.218,368.426,472.45,328.771,461.331,294.545z"

codes = {
  yazhou: [
    "AFG"
    "ARE"
    "ARM"
    "AZE"
    "BGD"
    "BRN"
    "BTN"
    "CHN"
    "-99"
    "GEO"
    "YEM"
    "IDN"
    "IND"
    "IRN"
    "IRQ"
    "ISR"
    "JOR"
    "JPN"
    "KAZ"
    "KGZ"
    "KHM"
    "KOR"
    "KWT"
    "LAO"
    "LBN"
    "LKA"
    "MMR"
    "MNG"
    "MYS"
    "NPL"
    "OMN"
    "PAK"
    "PHL"
    "PRK"
    "QAT"
    "SAU"
    "SYR"
    "THA"
    "TJK"
    "TKM"
    "TLS"
    "TUR"
    "UZB"
    "VNM"
    "PSE"
  ]

  feizhou: [
    "AGO"
    "BDI"
    "BEN"
    "BFA"
    "BWA"
    "CAF"
    "CIV"
    "CMR"
    "COD"
    "COG"
    "DJI"
    "DZA"
    "EGY"
    "ERI"
    "ZWE"
    "ETH"
    "GAB"
    "GHA"
    "GIN"
    "GMB"
    "GNB"
    "GNQ"
    "ZAF"
    "ZMB"
    "KEN"
    "LBR"
    "LBY"
    "LSO"
    "MAR"
    "MDG"
    "MLI"
    "MOZ"
    "MRT"
    "MWI"
    "NAM"
    "NER"
    "NGA"
    "RWA"
    "-99"
    "SDN"
    "SDS"
    "SEN"
    "SLE"
    "-99"
    "SOM"
    "SWZ"
    "TCD"
    "TGO"
    "TUN"
    "TZA"
    "UGA"
  ]

  ouzhou: [
    "ALB"
    "AUT"
    "BEL"
    "BGR"
    "BIH"
    "BLR"
    "CHE"
    "CYP"
    "CZE"
    "DEU"
    "DNK"
    "ESP"
    "EST"
    "FIN"
    "FRA"
    "GBR"
    "GRC"
    "HRV"
    "HUN"
    "IRL"
    "ISL"
    "ITA"
    "-99"
    "LTU"
    "LUX"
    "LVA"
    "MDA"
    "MKD"
    "MNE"
    "NLD"
    "NOR"
    "POL"
    "PRT"
    "ROU"
    "RUS"
    "SRB"
    "SVK"
    "SVN"
    "SWE"
    "UKR"
  ]

  nanmei: [
    "ARG"
    "BOL"
    "BRA"
    "CHL"
    "COL"
    "CUB"
    "ECU"
    "FLK"
    "GUY"
    "PAN"
    "PER"
    "PRY"
    "SUR"
    "URY"
    "VEN"
  ]

  nanji: [
    "ATA"
    "ATF"
  ]

  aozhou: [
    "AUS"
    "FJI"
    "NCL"
    "NZL"
    "PNG"
    "SLB"
    "VUT"
  ]

  beimei: [
    "BHS"
    "BLZ"
    "CAN"
    "CRI"
    "DOM"
    "GRL"
    "GTM"
    "HND"
    "HTI"
    "JAM"
    "MEX"
    "NIC"
    "PRI"
    "SLV"
    "TTO"
    "USA"
  ]
}


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

    countries = @g_map.selectAll('.country')
      .data @features
      .enter()
      .append 'path'
      .attr 'class', 'country'
      .attr 'd', @path
      .style 'stroke', @MAP_STROKE_COLOR
      .style 'stroke-width', 1
      .style 'fill', (d, idx)=>
        return '#bd0000' if d.id == 'CHN'
        return '#e8aa31' if d.id == '-99'

        return '#cc7561' if codes.yazhou.indexOf(d.id) > -1
        return '#3e9bbc' if codes.ouzhou.indexOf(d.id) > -1
        return '#e8aa31' if codes.feizhou.indexOf(d.id) > -1
        return '#d4e05a' if codes.nanmei.indexOf(d.id) > -1
        return '#bf79ff' if codes.aozhou.indexOf(d.id) > -1
        return '#8ee0a9' if codes.beimei.indexOf(d.id) > -1
        return '#ffffff' if codes.nanji.indexOf(d.id) > -1
        


  draw_heatmap: ->
    heatmapInstance = h337.create({
      # only container is required, the rest will be defaults
      container: jQuery('#heatmap')[0]
      radius: 16
      gradient:
        '0.0': '#ffffff'
        '0.3': '#ffffff'
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

    # @_r @cn_cities, '#ff283b', true
    # @_r @cn_cities, '#ff283b', true
    @_r @world_cities, '#ff283b', false
    # @_r @world_cities, '#ff283b', false

    setTimeout =>
      # @_r @cn_cities, '#cff1ae'
      # @_r @cn_cities, '#cff1ae'
      # @_r @world_cities, '#f1c4ae'
      # @_r @world_cities, '#f1c4ae'

      # @_r @cn_cities, '#ff283b', true
      # @_r @cn_cities, '#ff283b', true
      @_r @world_cities, '#ff283b', false
      # @_r @world_cities, '#ff283b', false
    , 20000

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