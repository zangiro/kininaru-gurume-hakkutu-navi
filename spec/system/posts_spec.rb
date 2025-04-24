require 'rails_helper'

RSpec.describe "Posts", type: :system do
  include LoginMacros

  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  describe "ログイン後" do
    before { login_as(user) }

    describe "記事作成" do
      context "フォームの入力値が正常" do
        xit "記事の作成が成功する" do
          visit new_post_path
          fill_in "料理名", with: "ごはん"
          attach_file "メイン画像", Rails.root.join("spec/fixtures/files/1.jpg")
          fill_in "出典", with: "出典A"
          fill_in "店舗情報", with: "店A"
          fill_in "一覧用紹介文", with: "いちらんせつめい"
          fill_in "詳細用紹介文", with: "しょうさいせつめい"
          fill_in "地域", with: "エリアA,エリアB"
          fill_in "ジャンル", with: "ジャンルA,ジャンルB"
          fill_in "味", with: "味A,味B"
          fill_in "その他", with: "その他A,その他B"
          click_button "登録"
          expect(page).to have_content "記事の作成をしました"
          expect(current_path).to eq user_posts_path(user)
        end
      end

      context "test" do
        it "記事" do
          visit new_post_path
          fill_in "料理名", with: "ごはん"
          attach_file "メイン画像", Rails.root.join("spec/fixtures/files/1.jpg")
          fill_in "詳細用紹介文", with: "しょうさいせつめい"
          fill_in "post[post_area_tags_attributes][0][area_tag_attributes][name]", with: "エリアA"
          click_button "登録"
          expect(current_path).to eq user_posts_path(user)
        end
      end

      context "test" do
        it "記事2" do
          visit new_post_path
          fill_in "料理名", with: ""
          attach_file "メイン画像", Rails.root.join("spec/fixtures/files/1.jpg")
          fill_in "post[post_area_tags_attributes][0][area_tag_attributes][name]", with: "エリアA"
          click_button "登録"
          expect(page).to have_content "失敗"
        end
      end
    end
  end
end
