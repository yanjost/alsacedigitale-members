class ApplicationController < BaseController
  before_action :registration_permitted_parameters, if: :devise_controller?

  # Doesn't work !!!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def index
    redirect_to :controller => 'users', :action => 'profile'
  end

    def registration_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit :first_name, :last_name, :email, :password, :street, :zipcode, :city, :country, :birth_date, :birth_place, :job_position, :personal_phone, :professional_phone
      end
    end
end
