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

  # 複数のタグを持てること
  # 記事を消したらtagもきえること
end
