class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン

      redirect_to root_path, success: t("flash_message.google_login_success")
    else
      begin
        signup_and_login(provider)
        # ユーザーが存在しない場合はプロバイダ情報を元に新規ユーザーを作成し、ログイン

        redirect_to root_path, success: t("flash_message.google_login_success")
      rescue StandardError => e
        # Rubyの例外クラスの一つ。rescueの部分で発生した例外を捕まえ、「e」に格納する
        redirect_to root_path, danger: t("flash_message.google_login_failure")
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :scope, :authuser, :prompt)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
