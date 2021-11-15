class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  
  def destroy?
    @user && @record.user_id == @user.id ||
    @user&.has_role?(:admin) ||
    @user && @record.lesson.course.user_id == @user.id
  end

end
