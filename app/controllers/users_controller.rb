# frozen_string_literal: true

class UsersController < ApplicationController
  include UsersHelper
  def show
    @user = User.find_by(id: params[:id])
  end
end
