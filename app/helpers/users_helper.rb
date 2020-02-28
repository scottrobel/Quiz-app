# frozen_string_literal: true

module UsersHelper
  private

  def require_admin_or_own_profile
    unless current_user.admin_user? || current_user.id == params[:id]
      flash[:alert] = 'you must be an admin to view other profiles!'
      redirect_to root_path
    end
  end
end
