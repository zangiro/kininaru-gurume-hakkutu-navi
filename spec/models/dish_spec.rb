require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'バリデーションチェック' do
    it 'dishモデルに定義したバリデーションが全て機能しているか' do
      dish = build(:dish)
      expect(dish).to be_valid
      expect(dish.errors).to be_empty
    end
  end
end
