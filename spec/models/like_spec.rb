require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーションチェック' do
    it '異なるユーザーが同じ投稿に「いいね」できること' do
      user1 = create(:user)
      user2 = create(:user)
      post = create(:post)

      like1 = create(:like, user: user1, post: post)
      like2 = build(:like, user: user2, post: post)

      expect(like2).to be_valid
    end

    it '同じユーザーが同じ投稿に対して複数回「いいね」をできないこと' do
      user = create(:user)
      post = create(:post)
      create(:like, user: user, post: post)  # 1回目の「いいね」

      like = build(:like, user: user, post: post)  # 2回目の「いいね」
      expect(like).not_to be_valid  # 2回目は無効であるべき
      expect(like.errors[:user_id]).to include('はすでに存在します')
    end
  end
end
