class BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do 
    if user_signed_in?
      if !current_user.is_active?
        flash[:error] = "validity"
      end
    end
  end
end
