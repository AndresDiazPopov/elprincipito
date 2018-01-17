class AdminRolePolicy < ApplicationPolicy

  def destroy?
    return true if user.has_role?(:admin)

    return false
  end

  class Scope < Scope
    def resolve
      if user.has_role? :admin
        scope.all
      else

      end
    end
  end

end
