class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update destroy_avatar]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, success: t("flash_message.user_create")
    else
      flash.now[:danger] = t("flash_message.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    result = Geocoder.search(@user.address).first
    if result
      @user.latitude = result.latitude
      @user.longitude = result.longitude
    end

    if params[:user][:avatar].present?
      @select_new_avatar = "1"
    end

    if @user.update(user_params)
      redirect_to user_path(current_user), success: t("flash_message.update_success")
    else
      flash.now[:danger] = t("flash_message.update_failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_avatar
    @user = current_user
    @user.avatar.purge
    redirect_to user_path(current_user), success: t("flash_message.delete")
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_public, :introduction, :address, :agree_terms, :avatar)
  end
end
