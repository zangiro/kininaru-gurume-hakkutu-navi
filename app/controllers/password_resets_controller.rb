class PasswordResetsController < ApplicationController
  before_action :redirect_if_logged_in, only: %i[new create edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    # ランダムなトークンを含むURLを記載したメールをユーザーに送信
    redirect_to login_path, success: t("flash_message.password_reset_request_sending")
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    not_authenticated if @user.blank?
  end
  # 「load_from_reset_password_token」はsorcery のメソッド。
  # 与えられたトークンを使ってユーザーを検索し、該当するユーザーオブジェクトを返す。
  # もしトークンが無効だったり、ユーザーが見つからなかったりすると、nil を返すことになる。

  # 「not_authenticated」はユーザーが認証されていない場合に呼び出されるメソッド。applicationコントローラーに記載。

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path
      flash[:success]= t("flash_message.password_reset_completion")
    else
      flash.now[:danger] = t("flash_message.failure")
      render :edit, status: :unprocessable_entity
    end
  end
  # 「change_password」はsorceryのメソッド。新しいパスワードをユーザーオブジェクトに設定し、パスワードを更新する処理を実行。
  # 成功でtrue、失敗（確認用のパスワードと異なる場合）でfalseを返す。
  # 「@user.password_confirmation」は後のif文がfalseでも値が更新されたままになりそうだけど弊害はなさそう。
end
