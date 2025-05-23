class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :admin_user

  def index
    @users = User.all
  end

  def show
  end
end
