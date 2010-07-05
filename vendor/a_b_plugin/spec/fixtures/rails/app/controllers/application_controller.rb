# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def controller_respond_to
    render :text => private_methods.collect(&:to_s).include?(params[:method]) ? '1' : '0'
  end
  
  def helper_respond_to
    render :inline => "<%= private_methods.collect(&:to_s).include?(params[:method]) ? 1 : 0 %>"
  end
  
  def get_cookie
    ABPlugin.instance = self
    render :text => ABPlugin::Cookies.get('a_b')
  end
  
  def set_cookie
    ABPlugin.instance = self
    ABPlugin::Cookies.set('a_b', 'test')
    render :nothing => true
  end
end