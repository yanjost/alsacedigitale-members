class Admin::AdminController < ApplicationController
  before_action :authenticate_user!

  before_action :ensure_user_is_admin!

  protected
  def ensure_user_is_admin!
    raise CanCan::Unauthorized unless current_user.admin?
  end

  protected
  def current_ability
    AdminAbility.new(current_user)
  end
end
