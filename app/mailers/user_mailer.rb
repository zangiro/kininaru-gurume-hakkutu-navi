class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def reset_password_email(user)
    @user = User.find(user.id)
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: "おれおれ",
         subject: "けんめ〜ぃ")
  end
  # このメソッドはPasswordResetsコントローラーのcreateメソッドの「@user&.deliver_reset_password_instructions!」によって使用されてると推察
  # 実際のメソッド名(reset_password_email)で使用していない感じなのでわかりにくい。引数の「user」も自動で設定されてそう
end
