class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :admin_user

  def index
  end

  def show
  end

  private

  def admin_user
    redirect_to tags_path unless current_user.admin?
  end
end
