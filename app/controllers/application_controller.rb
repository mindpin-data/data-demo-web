class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :add_xframe  
  def add_xframe  
    headers['X-Frame-Options'] = 'ALLOWALL'  
  end  
end
