require 'rails_helper'

RSpec.describe AreaTag, type: :model do
  
  describe 'バリデーションチェック' do
    it 'area_tagモデルに定義したバリデーションが全て機能しているか' do
      area_tag = build(:area_tag)
      expect(area_tag).to be_valid
      expect(area_tag.errors).to be_empty
    end

    it 'エリア名は必須項目であること' do
      area_tag = build(:area_tag, name: nil)
      area_tag.valid?
      expect(area_tag.errors[:name]).to include('を入力してください')
    end
  end

  describe 'アソシエーション' do
    it 'ひとつのarea_tagが複数の記事に関連付けできること' do
      area_tag = create(:area_tag)
      post1 = create(:post, area_tags: [area_tag])  # 1つ目の記事を作成
      post2 = create(:post, area_tags: [area_tag])  # 2つ目の記事を作成

      expect(area_tag.posts).to include(post1, post2)  # area_tagが両方の記事を持っていることを確認
    end
  end
end
