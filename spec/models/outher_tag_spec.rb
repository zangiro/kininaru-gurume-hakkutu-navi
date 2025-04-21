require 'rails_helper'

RSpec.describe OutherTag, type: :model do
  describe 'アソシエーション' do
    it 'ひとつのその他のタグが複数の記事に関連付けできること' do
      outher_tag = create(:outher_tag)
      post1 = create(:post, outher_tags: [outher_tag])  # 1つ目の記事を作成
      post2 = create(:post, outher_tags: [outher_tag])  # 2つ目の記事を作成

      expect(outher_tag.posts).to include(post1, post2)  # その他のタグが両方の記事を持っていることを確認
    end
  end
end
