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
end
