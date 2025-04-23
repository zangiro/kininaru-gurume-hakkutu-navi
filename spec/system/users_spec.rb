require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginMacros

  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "ログイン前" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザーの新規作成が成功する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: 'email@example.com'
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "ユーザーの新規作成をしました"
          expect(current_path).to eq root_path
        end
      end
    end

  end
end