class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :admin_user

  def index
    @users = User.order(:id).page(params[:page]).per(MAXIMUM_ADMINPAGE_USER)
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.includes(:user)
               .where(user: @user)
               .order(id: :asc)
               .page(params[:page]).per(MAXIMUM_ADMINPAGE_USER)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, success: t("flash_message.update_success")
    else
      flash.now[:danger] = t("flash_message.update_failure")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :account_status)
  end
end
