require 'rails_helper'

RSpec.describe ViewHistory, type: :model do
  describe 'アソシエーション' do
    it 'ユーザーと記事に対して閲覧履歴の関連付けができること' do
      user = create(:user)
      post = create(:post)
      view_history = create(:view_history, user: user, post: post)  # 閲覧履歴を作成

      expect(view_history.user).to eq(user)  # 作成した閲覧履歴のユーザーと最初に作成したuserが同じであることを確認してる
      expect(view_history.post).to eq(post)
    end
  end
end
