class ApplicationController < BaseController
  before_action :registration_permitted_parameters, if: :devise_controller?

  def index
    if user_signed_in?
      if !current_user.is_active?
        flash[:error] = "validity"
      end
    end
  end

    def registration_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit :first_name, :last_name, :email, :password, :street, :zipcode, :city, :country, :birth_date, :birth_place, :job_position, :personal_phone, :professional_phone
      end
    end
end
