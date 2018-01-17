class AdminUserPolicy < ApplicationPolicy

  def update_password?
    record == user
  end

  def edit_password?
    update_password?
  end

  def enable?
    record != user && user.has_role?(:admin)
  end

  def disable?
    enable?
  end

  def find_by_email?
    user.has_role?(:admin)
  end

  def create_admin?
    user.has_role?(:admin)
  end

  def add_role_admin?
    user.has_role?(:admin)
  end

  def show?
    user.has_role?(:admin) || record == user
  end

  def update?
    # user.has_role?(:admin) || record == user
    user.has_role?(:admin)
  end

  def new_admin?
    user.has_role?(:admin)
  end

  # Para la lista de admin_users
  def filter_by_state?
    user.has_role?(:admin)
  end

  # Para la lista de admin_users
  def filter_by_role?
    user.has_role?(:admin)
  end

  def index?
    user.has_role?(:admin)
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
