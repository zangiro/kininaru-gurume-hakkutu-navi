require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーションチェック' do
    it 'commentモデルに定義したバリデーションが全て機能しているか' do
      comment = build(:comment)
      expect(comment).to be_valid
      expect(comment.errors).to be_empty
    end

    it '本文は必須項目であること' do
      comment = build(:comment, body: nil)
      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーと記事に対してコメントの関連付けができること' do
      user = create(:user)
      post = create(:post)
      comment = create(:comment, user: user, post: post)  # コメントを作成

      expect(comment.user).to eq(user)  # 作成したコメントのユーザーと最初に作成したuserが同じであることを確認してる
      expect(comment.post).to eq(post)
    end
  end
end
