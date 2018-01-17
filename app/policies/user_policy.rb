class UserPolicy < ApplicationPolicy

  def enable?
    user.has_role?(:admin)
  end

  def disable?
    user.has_role?(:admin)
  end
  
end
