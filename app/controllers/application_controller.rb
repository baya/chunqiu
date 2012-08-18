class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper::Auth
  helper_method :current_user

end
