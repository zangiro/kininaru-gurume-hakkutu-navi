class UserSessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, success: t("flash_message.login_success")
    else
      flash.now[:danger] = t("flash_message.login_failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = t("flash_message.logout")
    redirect_to root_path, status: :see_other
  end
end
