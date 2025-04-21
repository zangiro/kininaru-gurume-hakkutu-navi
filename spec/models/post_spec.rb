require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションチェック' do
    it 'postモデルに定義したバリデーションが全て機能しているか' do
      post = build(:post)
      expect(post).to be_valid
      expect(post.errors).to be_empty
    end

    it 'タイトルは必須項目であること' do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include('を入力してください')
    end

    it 'メイン画像添付が必須項目であること' do
      user = create(:user)
      post = Post.new(title: "記事A", user: user)
      post.valid?
      expect(post.errors[:main_image]).to include('を添付してください')
    end
    # build(:post, main_image: nil)では作成できないのでテストケース内でPost作成

    it 'タイトルは255文字以下であること' do
      post = build(:post, title: 'a' * 256)
      post.valid?
      expect(post.errors[:title]).to include('は255文字以内で入力してください')
    end
  end

  describe 'アソシエーション' do
    it 'ひとつの記事が複数のエリアタグに関連付けできること' do
      post = create(:post)
      area_tag1 = create(:area_tag, posts: [post])  # 1つ目のタグを作成
      area_tag2 = create(:area_tag, posts: [post])  # 2つ目のタグを作成

      expect(post.area_tags).to include(area_tag1, area_tag2)
    end

    it 'ひとつの記事が複数のジャンルタグに関連付けできること' do
      post = create(:post)
      genre_tag1 = create(:genre_tag, posts: [post])  # 1つ目のタグを作成
      genre_tag2 = create(:genre_tag, posts: [post])  # 2つ目のタグを作成

      expect(post.genre_tags).to include(genre_tag1, genre_tag2)
    end

    it 'ひとつの記事が複数の味のタグに関連付けできること' do
      post = create(:post)
      taste_tag1 = create(:taste_tag, posts: [post])  # 1つ目のタグを作成
      taste_tag2 = create(:taste_tag, posts: [post])  # 2つ目のタグを作成

      expect(post.taste_tags).to include(taste_tag1, taste_tag2)
    end

    it 'ひとつの記事が複数のその他のタグに関連付けできること' do
      post = create(:post)
      outher_tag1 = create(:outher_tag, posts: [post])  # 1つ目のタグを作成
      outher_tag2 = create(:outher_tag, posts: [post])  # 2つ目のタグを作成

      expect(post.outher_tags).to include(outher_tag1, outher_tag2)
    end

    it 'postとdishが関連付けできること' do
      post = create(:post)
      dish = create(:dish, post: post)
    
      expect(post.dish).to eq(dish)
    end

    it 'postを削除すると関連するdishも削除されるか' do
      post = create(:post)
      create(:dish, post: post)
    
      expect { post.destroy }.to change { Dish.count }.by(-1) # ポストを削除したときにディッシュの数が1減るか確認
    end
  end
end
