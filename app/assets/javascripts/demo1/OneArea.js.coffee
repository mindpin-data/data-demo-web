# 一带一路，单个国旗图

class OneArea extends Graph
  prepare_data: ->
    @AREA_DATA = {}
    window.map_data.countries.forEach (x)=>
      @AREA_DATA[x.code] = {
        n: x.name
        d: x.total
        p: x.percent_change
      }

    @TOGGLE_AREAS = window.map_data.countries.map (x)->
      x.code

  draw: ->
    @prepare_data()

    @svg = @draw_svg()

    @current_area = @TOGGLE_AREAS[0]

    @draw_flag()
    @draw_texts()

    jQuery(document).on 'data-map:next-draw', =>
      @next_draw()

  next_draw: ->
    @prepare_data()

    @aidx = 0 if not @aidx?
    @aidx += 1
    @aidx = 0 if @aidx == @TOGGLE_AREAS.length
    @current_area = @TOGGLE_AREAS[@aidx]

    @draw_flag()
    @draw_texts()

  draw_flag: ->
    @flag.remove() if @flag?

    @flag = @svg.append('g')
      .attr 'class', 'flag'

    @flag
      .append 'image'
      .attr 'xlink:href', "images/countries/#{@current_area}.png"
      .attr 'height', @height - 60
      .attr 'width', (@height - 60) / 2 * 3
      .attr 'x', 0
      .attr 'y', 30

  draw_texts: ->
    @texts.remove() if @texts?

    @texts = texts = @svg.append('g')
      .attr 'class', 'texts'
      .style 'transform', 'translate(210px, 0px)'

    size = 30
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 20
      .attr 'dy', '.33em'
      .text "#{@AREA_DATA[@current_area].n}销量"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    size1 = 40
    number = texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 20 + 50
      .attr 'dy', '.33em'
      .text 0
      .style 'font-size', size1 + 'px'
      .style 'fill', '#ffde00'

    jQuery({d: 0}).animate({d: @AREA_DATA[@current_area].d}
      {
        step: (now)->
          number.text Math.floor(now)
        duration: 1000
      }
    )


    size2 = 30
    percent = texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 20 + 50 + 50
      .attr 'dy', '.33em'
      .text "同比 #{0.0}%"
      .style 'font-size', size2 + 'px'
      .style 'fill', '#ffffff'

    jQuery({p: 0}).animate({p: @AREA_DATA[@current_area].p}
      {
        step: (now)->
          t = Math.floor(now * 10) / 10
          t = "#{t}.0" if t == ~~t

          percent.text "同比 #{t}%"
        duration: 1000
      }
    )

    texts
      .append 'image'
      .attr 'x', 160
      .attr 'y', size / 2 + 20 + 50 + 50 - 15
      .attr 'xlink:href', 'images/upicon1.png'
      .attr 'height', size2
      .attr 'width', size2



BaseTile.register 'one-area', OneArea