class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    # ランダムなトークンを含むURLを記載したメールをユーザーに送信
    redirect_to login_path, success: "@申請送信をしました"
  end

  def edit
    #@token = params[:id]
    #@user = User.load_from_reset_password_token(params[:id])
    #not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path
      flash[:success]= 'パスワードがリセットされました'
    else
      render action: 'edit'
      # もしくは
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end
end
