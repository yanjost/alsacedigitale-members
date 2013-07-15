class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User, :user_email => user.email
  end
end

class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, User
  end
end
