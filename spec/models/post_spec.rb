require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションチェック' do
    it 'postモデルに定義したバリデーションが全て機能しているか' do
      post = build(:post)
      expect(post).to be_valid
      expect(post.errors).to be_empty
    end
  end

  # 複数のタグを持てること
  # 記事を消したらtagもきえること
end
