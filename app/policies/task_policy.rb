class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.teacher?
        scope.where(course: user.teacher_courses + user.courses)
      else
        scope.where(course: user&.courses)
      end
    end
  end

  def create?
    user_is_course_teacher?(record.course)
  end

  def update?
    user_is_course_teacher?(record.course)
  end

  def destroy?
    user_is_course_teacher?(record.course)
  end

  def list_solutions?
    user_is_course_teacher?(record.course)
  end

  def solve?
    record.course.has_student?(user) && !record.solved_by?(user)
  end
end