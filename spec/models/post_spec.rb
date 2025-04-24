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

    # ーーーーーーーーーーーー関連付け確認ーーーーーーーーーーーーー

    it 'ひとつの記事が複数のエリアタグに関連付けできること' do
      post = create(:post)
      area_tag1 = create(:area_tag, posts: [ post ])  # 1つ目のタグを作成
      area_tag2 = create(:area_tag, posts: [ post ])  # 2つ目のタグを作成

      expect(post.area_tags).to include(area_tag1, area_tag2)
    end

    it 'ひとつの記事が複数のジャンルタグに関連付けできること' do
      post = create(:post)
      genre_tag1 = create(:genre_tag, posts: [ post ])  # 1つ目のタグを作成
      genre_tag2 = create(:genre_tag, posts: [ post ])  # 2つ目のタグを作成

      expect(post.genre_tags).to include(genre_tag1, genre_tag2)
    end

    it 'ひとつの記事が複数の味のタグに関連付けできること' do
      post = create(:post)
      taste_tag1 = create(:taste_tag, posts: [ post ])  # 1つ目のタグを作成
      taste_tag2 = create(:taste_tag, posts: [ post ])  # 2つ目のタグを作成

      expect(post.taste_tags).to include(taste_tag1, taste_tag2)
    end

    it 'ひとつの記事が複数のその他のタグに関連付けできること' do
      post = create(:post)
      outher_tag1 = create(:outher_tag, posts: [ post ])  # 1つ目のタグを作成
      outher_tag2 = create(:outher_tag, posts: [ post ])  # 2つ目のタグを作成

      expect(post.outher_tags).to include(outher_tag1, outher_tag2)
    end

    it '記事と記事説明(dish)が関連付けできること' do
      post = create(:post)
      dish = create(:dish, post: post)
    
      expect(post.dish).to eq(dish)
    end

    it 'ひとつの記事が複数のいいね(like)に関連付けできること' do
      post = create(:post)
      like1 = create(:like, post: post)
      like2 = create(:like, post: post)

      expect(post.likes).to include(like1, like2)
    end

    it 'ひとつの記事が複数のコメントに関連付けできること' do
      post = create(:post)
      comment1 = create(:comment, post: post)
      comment2 = create(:comment, post: post)

      expect(post.comments).to include(comment1, comment2)
    end

    it 'ひとつの記事が閲覧履歴に関連付けできること' do
      post = create(:post)
      view_history1 = create(:view_history, post: post)
      view_history2 = create(:view_history, post: post)

      expect(post.view_histories).to include(view_history1, view_history2)
    end

    # ーーーーーーーーーーーー関連付け確認ーーーーーーーーーーーーー

    # ーーーーーーーーーーーー削除確認ーーーーーーーーーーーーー

    it '記事を削除すると関連するpost_area_tagsも削除されるか' do
      post = create(:post)
      area_tag = create(:area_tag)
      post_area_tag = create(:post_area_tag, post: post, area_tag: area_tag)
    
      expect { post.destroy }.to change { PostAreaTag.count }.by(-1) # ポストを削除したときにpost_area_tagsの数が1減るか確認
    end

    it '記事を削除すると関連するpost_genre_tagsも削除されるか' do
      post = create(:post)
      genre_tag = create(:genre_tag)
      post_genre_tag = create(:post_genre_tag, post: post, genre_tag: genre_tag)
    
      expect { post.destroy }.to change { PostGenreTag.count }.by(-1) # ポストを削除したときに中間テーブルの数が1減るか確認
    end

    it '記事を削除すると関連するpost_taste_tagsも削除されるか' do
      post = create(:post)
      taste_tag = create(:taste_tag)
      post_taste_tag = create(:post_taste_tag, post: post, taste_tag: taste_tag)
    
      expect { post.destroy }.to change { PostTasteTag.count }.by(-1) # ポストを削除したときに中間テーブルの数が1減るか確認
    end

    it '記事を削除すると関連するpost_outher_tagsも削除されるか' do
      post = create(:post)
      outher_tag = create(:outher_tag)
      post_outher_tag = create(:post_outher_tag, post: post, outher_tag: outher_tag)
    
      expect { post.destroy }.to change { PostOutherTag.count }.by(-1) # ポストを削除したときに中間テーブルの数が1減るか確認
    end

    it 'postを削除すると関連するdishも削除されるか' do
      post = create(:post)
      create(:dish, post: post)
    
      expect { post.destroy }.to change { Dish.count }.by(-1) # ポストを削除したときにディッシュの数が1減るか確認
    end

    it '記事を削除すると関連するいいね(like)も削除されるか' do
      post = create(:post)
      like = create(:like, post: post)
    
      expect { post.destroy }.to change { Like.count }.by(-1)
    end

    it '記事を削除すると関連するコメントも削除されるか' do
      post = create(:post)
      comment = create(:comment, post: post)
    
      expect { post.destroy }.to change { Comment.count }.by(-1)
    end

    it '記事を削除すると関連する閲覧履歴も削除されるか' do
      post = create(:post)
      view_history = create(:view_history, post: post)
    
      expect { post.destroy }.to change { ViewHistory.count }.by(-1)
    end

    # ーーーーーーーーーーーー削除確認ーーーーーーーーーーーーー
  end
end
