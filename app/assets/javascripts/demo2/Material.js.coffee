# 原料产地：作物图标，目前未启用

class Material extends Graph
  prepare_data: ->
    @materials = window.map_data.materials

  draw: ->
    console.log(1111111111)
    @prepare_data()

    @svg = @draw_svg()

    @idx = -1
    @_draw()

    jQuery(document).on 'data-map:next-draw', =>
      @prepare_data()
      @_draw()

  _draw: ->
    @idx += 1
    @idx = 0 if @idx == 3
    @current_product = @materials[@idx]

    @draw_icon()
    @draw_texts()

  draw_icon: ->
    @flag.remove() if @flag?

    @flag = @svg.append('g')
      .attr 'class', 'flag'

    @flag
      .append 'circle'
      .attr 'r', @height / 4
      .attr 'cx', 80
      .attr 'cy', @height / 2
      .attr 'fill', @current_product.color
      .style 'opacity', '0.5'

    @flag
      .append 'image'
      .attr 'xlink:href', "images/materials/#{@current_product.name}.png"
      .attr 'height', @height / 6 * 2
      .attr 'width', @height / 6 * 2
      .attr 'x', 80 - @height / 6
      .attr 'y', @height / 2 - @height / 6

  draw_texts: ->
    @svg.select('g.texts').remove()

    texts = @svg.append('g')
      .attr 'class', 'texts'
      .style 'transform', 'translate(160px, 48px)'

    @draw_text texts, '即时采购价', @current_product.current_now, 0, true
    @draw_text texts, '去年同期价', @current_product.current_history, 40
    @draw_text texts, '当前指导价', @current_product.current_guiding, 80


  draw_text: (texts, label, number, y, flag = false)->
    size = 20
    texts
      .append 'text'
      .attr 'x', 0
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text label
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    tn = texts
      .append 'text'
      .attr 'x', 110
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text number
      .style 'font-size', size + 'px'
      .style 'fill', '#ffde00'

    jQuery({ n: 0 }).animate({ n: number }
      {
        step: (now)->
          tn.text ~~(now * 1000) / 1000
      }
    )

    texts
      .append 'text'
      .attr 'x', 170
      .attr 'y', size / 2 + 10 + y
      .attr 'dy', '.33em'
      .text "万元 / 吨"
      .style 'font-size', size + 'px'
      .style 'fill', '#ffffff'

    if flag
      tp = texts
        .append 'text'
        .attr 'x', 270
        .attr 'y', size / 2 + 10 + y
        .attr 'dy', '.33em'
        .text "2.34‰"
        .style 'font-size', size + 'px'
        .style 'fill', '#ffffff'

      jQuery({ n: 0 }).animate({ n: @current_product.percent_change }
        {
          step: (now)->
            tp.text "#{~~(now * 100) / 100}‰"
        }
      )

      texts
        .append 'image'
        .attr 'x', 330
        .attr 'y', size / 2 + 10 - size / 2 + y
        .attr 'xlink:href', 'images/downicon1.png'
        .attr 'height', size
        .attr 'width', size



BaseTile.register 'material', Material