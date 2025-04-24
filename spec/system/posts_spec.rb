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
        it "記事の作成が成功する" do
          visit new_post_path
          fill_in "料理名", with: "ごはん"
          attach_file "メイン画像", Rails.root.join("spec/fixtures/files/1.jpg")
          fill_in "出典", with: "出典A"
          fill_in "店舗情報", with: "店A"
          fill_in "一覧用紹介文", with: "いちらんせつめい"
          fill_in "詳細用紹介文", with: "しょうさいせつめい"
          fill_in "post[post_area_tags_attributes][0][area_tag_attributes][name]", with: "エリアA,エリアB"
          fill_in "post[post_genre_tags_attributes][0][genre_tag_attributes][name]", with: "ジャンルA,ジャンルB"
          fill_in "post[post_taste_tags_attributes][0][taste_tag_attributes][name]", with: "味A,味B"
          fill_in "post[post_outher_tags_attributes][0][outher_tag_attributes][name]", with: "その他A,その他B"
          # text_field_tagを使っている場合は、fill_inで指定する名前も実際の名前に合わせる必要がある
          click_button "登録"
          expect(page).to have_content "記事の作成をしました"
          expect(current_path).to eq user_posts_path(user)
        end
      end

      context "料理名が未入力" do
        it "記事の作成が失敗する" do
          visit new_post_path
          fill_in "料理名", with: ""
          attach_file "メイン画像", Rails.root.join("spec/fixtures/files/1.jpg")
          fill_in "出典", with: "出典A"
          fill_in "店舗情報", with: "店A"
          fill_in "一覧用紹介文", with: "いちらんせつめい"
          fill_in "詳細用紹介文", with: "しょうさいせつめい"
          fill_in "post[post_area_tags_attributes][0][area_tag_attributes][name]", with: "エリアA,エリアB"
          fill_in "post[post_genre_tags_attributes][0][genre_tag_attributes][name]", with: "ジャンルA,ジャンルB"
          fill_in "post[post_taste_tags_attributes][0][taste_tag_attributes][name]", with: "味A,味B"
          fill_in "post[post_outher_tags_attributes][0][outher_tag_attributes][name]", with: "その他A,その他B"
          click_button "登録"
          expect(page).to have_content "記事の作成に失敗しました"
          expect(page).to have_content "タイトルを入力してください"
          expect(current_path).to eq posts_path
          # render :new実行後はnew_post_pathではなくposts_path
        end
      end
    end
  end
end
