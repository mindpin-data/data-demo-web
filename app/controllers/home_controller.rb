class HomeController < ApplicationController
  def demo
    @demo = params[:demo]

    @title = {
      'demo1' => '一带一路国家销售',
      'demo2' => '原料产地监控',
      'demo3' => '出口销量（大）',
      'demo4' => '出口销量（小）'
    }[@demo]

    render template: "home/#{@demo}.html.haml"
  end

  def data
    data = case params[:demo]
      when 'demo1'
        d = DemoData.demo1
        # d[:countries][0][:total] = 3000000
        # d
      when 'demo2'
        DemoData.demo2
      when 'demo3', 'demo4'
        DemoData.demo3
    end

    render json: data
  end
end
