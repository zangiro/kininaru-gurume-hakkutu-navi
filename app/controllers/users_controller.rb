class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, success: "@ユーザーの新規作成をしました"
    else
      flash.now[:danger] = "@失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @avatar = user_params[:avatar]

    # if user_params[:name].present? && user_params[:email].present?
    #   unless @avatar.nil?
    #     @user.avatar.purge
    #   end
    # end

    # if @user.update(user_params)
    #   redirect_to user_path(current_user), success: "@更新しました"
    # else
    #   flash.now[:danger] = "@更新失敗しました"
    #   render :edit, status: :unprocessable_entity
    # end

    redirect_to root_path
  end

  def destroy_avatar
    @user = current_user
    @user.avatar.purge

    redirect_to root_path, success: "@削除しました"
  end

  def aws_test_delete
    #@test1 = ActiveStorage::Blob.unattached.find_each   #エラー出ず
    ActiveStorage::Blob.unattached.find_each(&:purge)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_public, :introduction, :agree_terms, :avatar)
  end
end
