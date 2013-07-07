class ApplicationController < ActionController::Base
  before_action :registration_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

    def registration_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit :first_name, :last_name, :email, :password, :street, :zipcode, :city, :country, :birth_date, :birth_place, :job_position, :personal_phone, :professional_phone
      end
    end
end
