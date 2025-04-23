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
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "ユーザーの新規作成をしました"
          expect(current_path).to eq root_path
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "メールアドレスを入力してください"
          expect(current_path).to eq users_path
          # render :newが行わてたときnew_user_pathではなくusers_pathと判定されるみたい
        end
      end

      context "名前が未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: ""
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "名前を入力してください"
          expect(current_path).to eq users_path
        end
      end

      context "パスワードが未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: ""
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "パスワードは3文字以上で入力してください"
          expect(current_path).to eq users_path
        end
      end

      context "パスワード再確認が未入力" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: ""
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "再確認用パスワードを入力してください"
          expect(current_path).to eq users_path
        end
      end

      context "利用規約に同意されてない" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "利用規約に同意されてません"
          expect(current_path).to eq users_path
        end
      end

      context "パスワードとパスワード再確認が一致しない" do
        it "ユーザーの新規作成が失敗する" do
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "aiueo"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "再確認用パスワードとパスワードの入力が一致しません"
          expect(current_path).to eq users_path
        end
      end

      context "メールアドレスがすでに存在する" do
        it "ユーザーの新規作成が失敗する" do
          existed_user = create(:user, email: "email@example.com")
          visit new_user_path
          fill_in "名前", with: "田中"
          fill_in "メールアドレス", with: "email@example.com"
          fill_in "パスワード", with: "password"
          fill_in "再確認", with: "password"
          check "利用規約に同意しますか？"
          click_button "登録"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "メールアドレスはすでに存在します"
          expect(current_path).to eq users_path
        end
      end

    end
  end

  describe "ログイン後" do
    before { login_as(user) }

    describe "ユーザー編集" do
      context "フォームの入力値が正常" do
        it "ユーザーの編集が成功する" do
          visit edit_user_path(user)
          fill_in "名前", with: "佐藤"
          fill_in "メールアドレス", with: "update@example.com"
          fill_in "自己紹介", with: "こんにちは"
          click_button "変更"
          expect(page).to have_content "更新しました"
          expect(current_path).to eq user_path(user)
        end
      end

      context "名前が空白" do
        it "ユーザーの編集が失敗する" do
          visit edit_user_path(user)
          fill_in "名前", with: ""
          fill_in "メールアドレス", with: "update@example.com"
          fill_in "自己紹介", with: "こんにちは"
          click_button "変更"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "名前を入力してください"
          expect(current_path).to eq user_path(user)
          # current_pathはedit_user_path(user)ではなくこっちが正常なよう
        end
      end

      context "メールアドレスが空白" do
        it "ユーザーの編集が失敗する" do
          visit edit_user_path(user)
          fill_in "名前", with: "佐藤"
          fill_in "メールアドレス", with: ""
          fill_in "自己紹介", with: "こんにちは"
          click_button "変更"
          expect(page).to have_content "失敗しました"
          expect(page).to have_content "メールアドレスを入力してください"
          expect(current_path).to eq user_path(user)
        end
      end
    end
    
  end
end