module QuizzesHelper
  private

  def require_admin
    unless current_user &. admin_user?
      flash[:alert] = "Only Admins Can See That Page!"
      redirect_to root_path
    end
  end
end
