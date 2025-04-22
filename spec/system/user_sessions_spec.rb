require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  include LoginMacros

  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "ログイン前" do
    context "フォームの入力値が正常" do
      it "ログイン処理が成功する" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"
        click_button "ログイン"
        expect(page).to have_content "ログインしました"
        expect(current_path).to eq root_path
      end
    end

  end
end
