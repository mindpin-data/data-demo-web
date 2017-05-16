class LineChartTitle extends Graph
  prepare_data: ->
    @total_data = window.map_data.total
    @export_data = window.map_data.export

  draw: ->
    @prepare_data()

    @svg = @draw_svg()

    @c1 = '#00c713'
    @c2 = '#578eff'
    @c3 = '#ff8711'

    @number_color = '#ffde00'

    @draw_texts()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @draw_texts()

  draw_texts: ->
    @texts.remove() if @texts?

    texts = @texts = @svg.append('g')
      .style 'transform', 'translate(1100px, 0px)'

    scale = 1
    left  = 200

    if jQuery('.paper.large')[0]
      scale = 2
      left = 1600

    size = 40 * scale
    texts
      .append 'text'
      .attr 'x', -1050
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '产品总体销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'


    t1 = texts
      .append 'text'
      .attr 'x', -1050 + 270 * scale
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text @total_data
      .style 'font-size', "#{size * 1.5}px"
      .style 'fill', @number_color

    jQuery({n: 0}).animate({n: @total_data}
      {
        step: (now)->
          t1.text ~~now
      }
    )


    texts
      .append 'text'
      .attr 'x', -1050 + 600 * scale
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text '产品出口销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'


    t2 = texts
      .append 'text'
      .attr 'x', -1050 + (600 + 270) * scale
      .attr 'y', @height / 2
      .attr 'dy', '.33em'
      .text @export_data
      .style 'font-size', "#{size * 1.5}px"
      .style 'fill', @number_color

    jQuery({n: 0}).animate({n: @export_data}
      {
        step: (now)->
          t2.text ~~now
      }
    )


    size = 20 * scale
    # left = 400 / scale
    topoff = 16 * scale

    texts
      .append 'rect'
      .attr 'x', left
      .attr 'y', @height / 2 - 7 + topoff
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c1

    texts
      .append 'text'
      .attr 'x', left + 40 * scale
      .attr 'y', @height / 2 + topoff
      .attr 'dy', '.33em'
      .text '实际销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', left + 140 * scale
      .attr 'y', @height / 2 - 7 + topoff
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c2

    texts
      .append 'text'
      .attr 'x', left + 180 * scale
      .attr 'y', @height / 2 + topoff
      .attr 'dy', '.33em'
      .text '预测销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

    texts
      .append 'rect'
      .attr 'x', left + 280 * scale
      .attr 'y', @height / 2 - 7 + topoff
      .attr 'width', 30
      .attr 'height', 15
      .style 'fill', @c3

    texts
      .append 'text'
      .attr 'x', left + 320 * scale
      .attr 'y', @height / 2 + topoff
      .attr 'dy', '.33em'
      .text '上年同比销量'
      .style 'font-size', "#{size}px"
      .style 'fill', '#ffffff'

BaseTile.register 'line-chart-title', LineChartTitle