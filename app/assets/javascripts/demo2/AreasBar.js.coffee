# 原料产地：预警窗口

class AreasBar extends Graph
  prepare_data: ->
    @scourges = window.map_data.scourges

  draw: ->
    @prepare_data()

    @svg = @draw_svg()
    @draw_stitle()
    @draw_infos()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @draw_infos()

  draw_stitle: ->
    size = 24

    @svg
      .append 'text'
      .attr 'x', 120
      .attr 'y', size / 2 + 30
      .attr 'dy', '.33em'
      .text "原料产地自然灾害预警"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    if @scourges.length == 0
      @svg
        .append 'text'
        .attr 'x', 140
        .attr 'y', size / 2 + 30 + 40
        .attr 'dy', '.33em'
        .text "目前没有灾害预警信息"
        .style 'font-size', size + 'px'
        .style 'fill', '#ffffff'

  draw_infos: ->
    @panel.remove() if @panel?

    @panel = @svg.append('g')
      .style 'transform', 'translate(-30px, 70px)'

    top = 0
    @scourges.forEach (x)=>
      @draw_info @panel, "images/scourges/#{x.icon}.png", x.name, "近期#{x.scourge}", x.date, top
      top += 40

  draw_info: (panel, img, city, weather, date, y = 0)->

    size = 20

    left = 70
    img_width = 40
    gap = size

    panel
      .append 'image'
      .attr 'x', left
      .attr 'y', size / 2 + y
      .attr 'xlink:href', img
      .attr 'height', 40 + 'px'
      .attr 'width', img_width + 'px'

    left1 = left + img_width + gap
    panel
      .append 'text'
      .attr 'x', left1
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text city
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    left2 = left1 + size * 3 + gap
    panel
      .append 'text'
      .attr 'x', left2
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text weather
      .style 'font-size', size + 'px'
      .style 'fill', '#f66'

    left3 = left2 + size * 4 + gap
    panel
      .append 'text'
      .attr 'x', left3
      .attr 'y', size / 2 + 20 + y
      .attr 'dy', '.33em'
      .text date + ' 11:11'
      .style 'font-size', size + 'px'
      .style 'fill', '#ffde00'


BaseTile.register 'areas-bar', AreasBar