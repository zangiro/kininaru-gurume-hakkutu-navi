require 'rails_helper'

RSpec.describe TasteTag, type: :model do
  describe 'アソシエーション' do
    it 'ひとつのtaste_tagが複数の記事に関連付けできること' do
      taste_tag = create(:taste_tag)
      post1 = create(:post, taste_tags: [taste_tag])  # 1つ目の記事を作成
      post2 = create(:post, taste_tags: [taste_tag])  # 2つ目の記事を作成

      expect(taste_tag.posts).to include(post1, post2)  # taste_tagが両方の記事を持っていることを確認
    end
  end
end
