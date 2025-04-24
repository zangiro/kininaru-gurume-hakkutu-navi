require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'アソシエーション' do
    it 'ユーザーに対してauthenticationsの関連付けができること' do
      user = create(:user)
      authentication = create(:authentication, user: user, provider: 'github', uid: '12345')

      expect(authentication.user).to eq(user)
    end
  end
end
