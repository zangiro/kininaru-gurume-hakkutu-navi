require 'rails_helper'

RSpec.describe GenreTag, type: :model do
  describe 'アソシエーション' do
    it 'ひとつのgenre_tagが複数の記事に関連付けできること' do
      genre_tag = create(:genre_tag)
      post1 = create(:post, genre_tags: [genre_tag])  # 1つ目の記事を作成
      post2 = create(:post, genre_tags: [genre_tag])  # 2つ目の記事を作成

      expect(genre_tag.posts).to include(post1, post2)  # genre_tagが両方の記事を持っていることを確認
    end
  end
end
