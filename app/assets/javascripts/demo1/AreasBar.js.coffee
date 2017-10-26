# 一带一路，带国旗的条状图

class AreasBar extends Graph
  prepare_data: ->
    countries = window.map_data.countries

    top = (countries.sort (a, b)-> 
      b.total - a.total
    )[0..5]

    @topmax = top[0].total
    @farr = top.map (x)-> x.code
    @amounts = top.map (x)-> x.total
    @names = top.map (x)-> x.name

  draw: ->
    @prepare_data()
    @svg = @draw_svg()

    @make_defs()
    @draw_flags()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @draw_flags()


  make_defs: ->
    # https://www.w3cplus.com/svg/svg-linear-gradients.html

    defs = @svg.append('defs')
    lg = defs.append('linearGradient')
      .attr 'id', 'areas-bar-linear'
      .attr 'x1', '0%'
      .attr 'y1', '0%'
      .attr 'x2', '100%'
      .attr 'y2', '0%'

    lg.append('stop')
      .attr 'offset', '0%'
      .attr 'stop-color', '#7184a3'

    lg.append('stop')
      .attr 'offset', '100%'
      .attr 'stop-color', '#f9f9f7'

  draw_flags: ->
    @flags.remove() if @flags

    @flags = @svg.append('g')

    max = @topmax
    # console.log(max)

    h = @height / 5
    w = @width * 0.8 - 100
    for f, idx in @farr
      @draw_flag @flags, f, h, w, idx, @amounts, max, @names

  draw_flag: (flags, f, h, w, idx, amounts, max, names)->
    flag = flags
      .append 'image'
      .attr 'xlink:href', "images/countries/#{f}.png"
      .attr 'height', h - 30
      .attr 'width', (h - 30) / 2 * 3
      .attr 'x', 0
      .attr 'y', h * idx + 30

    offl = 80

    amount = amounts[idx]
    bh = h - 30
    bw = w * (amount / max) + 80

    bar = flags
      .append('rect')
      .attr 'fill', 'url(#areas-bar-linear)'
      .attr 'width', bw
      .attr 'height', bh
      .attr 'x', offl
      .attr 'y', h * idx + 30

    th = 24
    text = flags
      .append 'text'
      .attr 'fill', '#011224'
      .attr 'x', offl + 5
      .attr 'y', h * idx + 30 + bh / 2
      .attr 'dy', '.33em'
      .style 'font-size', th + 'px'
      .text names[idx]

    th1 = 30
    text1 = flags
      .append 'text'
      .attr 'fill', '#011224'
      .attr 'text-anchor', 'end'
      .attr 'x', offl + bw - 5
      .attr 'y', h * idx + 30 + bh / 2
      .attr 'dy', '.33em'
      .style 'font-size', th1 + 'px'
      .style 'font-weight', 'bold'
      .text amount

    jQuery({w: 100}).animate({w: bw}
      {
        step: (now)->
          bar.attr 'width', now
          text1.attr 'x', offl + now - 5
        duration: 1000
      }
    )

    jQuery({a: 0}).animate({a: amount}
      {
        step: (now)->
          text1.text Math.floor(now)
        duration: 1000
      }
    )

BaseTile.register 'areas-bar', AreasBar