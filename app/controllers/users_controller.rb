class UsersController < ApplicationController
  include UsersHelper
  before_action :require_admin_or_own_profile, only: [:show]
  def show
    @user = User.find_by(id: params[:id])
  end
end
