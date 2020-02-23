class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :require_admin
  def new
  end
end
