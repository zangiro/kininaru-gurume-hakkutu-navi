class UserSessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]
  before_action :redirect_if_logged_in, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      if @user.account_status == ACCOUNT_STATUS_INACTIVE
        # account_statusがACCOUNT_STATUS_INACTIVE(つまり 1 で停止中）ならログアウト
        logout
        redirect_to root_path, danger: t("flash_message.account_is_suspended")
        return
      end
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
