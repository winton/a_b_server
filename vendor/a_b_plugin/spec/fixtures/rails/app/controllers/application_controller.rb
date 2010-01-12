# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def controller_respond_to
    render :text => private_methods.include?(params[:method].intern) ? '1' : '0'
  end
  
  def helper_respond_to
    render :inline => "<%= private_methods.include?(params[:method].intern) ? 1 : 0 %>"
  end
end
