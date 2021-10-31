class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def index?
    @user&.has_role?(:admin)
  end
  
  def update?
    @record.user_id == @user.id
  end
 
  def edit?
    @user && @record.user_id == @user.id
  end 
  
  def destroy?
    @user&.has_role?(:admin)
  end
  
end
