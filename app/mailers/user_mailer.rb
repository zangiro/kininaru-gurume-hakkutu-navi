class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find(user.id)
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         from: "test@example.com",
         subject: "パスワードリセット")
  end
  # このメソッドはPasswordResetsコントローラーのcreateメソッドの「@user&.deliver_reset_password_instructions!」によって使用されてると推察
  # 実際のメソッド名(reset_password_email)で使用していない感じなのでわかりにくい。引数の「user」も自動で設定されてそう

  # 「reset_password_token」はsorceryのメソッド？。パスワードリセットに必要なトークンを生成。パスワードリセットをリクエストし時トークンを生成してデータベースに保存する
  # 「edit_password_reset_url」はRailsのURLヘルパーでパスワードリセット用の編集ページのURLを生成するメソッド
end
