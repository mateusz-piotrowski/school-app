class PagesController < ApplicationController
  expose(:courses, from: :current_user)
  expose(:teacher_courses, from: :current_user)

  def home
    skip_authorization
    return unless user_signed_in?
    render 'dashboard'
  end
end
