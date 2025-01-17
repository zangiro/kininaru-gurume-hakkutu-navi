class UserSessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, success: "@ログインしました"
    else
      flash.now[:danger] = "@ログインに失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = "@ログアウトしました"
    redirect_to root_path, status: :see_other
  end
end
