class HomeController < ApplicationController
  def demo
    @demo = params[:demo]
    render template: "home/#{@demo}.html.haml"
  end
end
