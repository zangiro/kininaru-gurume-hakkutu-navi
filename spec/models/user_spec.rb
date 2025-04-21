require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    # describeブロックはテスト対象のクラスやメソッドなどのグループを定義

    it 'userモデルに定義したバリデーションが全て機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    # expectメソッドは値を検証する。「expect(テスト対象の値).to マッチャー(期待する値)」と使う
    # be_valid...バリデーションに通るかどうかを検証
    # be_invalid...バリデーションに通らない状態であることを確認
    # be_empty ...テスト対象が空か確認

    # factory botで定義したデータを利用↓
    # create(:xxx)   データベースにレコードを作成しオブジェクト生成
    # build(:xxx)    データベースにレコードを作成せずオブジェクト生成

    # factory botで定義したデータの特定の値を上書き
    # create(:xxx, name: "Bさん")

    it '名前、メールアドレス、パスワードの再入力、利用規約の同意は必須項目であること' do
      user = build(:user, name: nil, email: nil, password_confirmation: nil, agree_terms: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
      expect(user.errors[:email]).to include('を入力してください')
      expect(user.errors[:password_confirmation]).to include('を入力してください')
      expect(user.errors[:agree_terms]).to include('に同意されてません')
    end

    it 'パスワードは3文字以上であること' do
      user = build(:user, password: 'aa')
      user.valid?
      expect(user.errors[:password]).to include('は3文字以上で入力してください')
    end

    it '名前は255文字以下であること' do
      user = build(:user, name: 'a' * 256)
      user.valid?
      expect(user.errors[:name]).to include('は255文字以内で入力してください')
    end

    # 特定の文字を含むか確認「to include」「to eq」
    # to include...配列の中にその値があればOK
    # to eq...文字列と完全に一致するかをチェックしている。これは単一の値の比較になるから、配列全体がその文字列である必要がある
    # エラーメッセージが配列に含まれているか確認したい場合はincludeを使うのが一般的

    it 'メールアドレスはユニークであること' do
      user1 = create(:user)
      user2 = build(:user)
      user2.email = user1.email
      user2.valid?
      expect(user2.errors[:email]).to include('はすでに存在します')
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーは複数のポストを持てること' do
      user = create(:user)
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)

      expect(user.posts).to include(post1, post2)
    end

    it 'ユーザーは複数のいいね(like)を持てること' do
      user = create(:user)
      like1 = create(:like, user: user)
      like2 = create(:like, user: user)
      
      expect(user.likes).to include(like1, like2)
    end

    it 'ユーザーは複数のコメントを持てること' do
      user = create(:user)
      comment1 = create(:comment, user: user)
      comment2 = create(:comment, user: user)
      
      expect(user.comments).to include(comment1, comment2)
    end

    it 'ユーザーは複数の閲覧履歴を持てること' do
      user = create(:user)
      view_history1 = create(:view_history, user: user)
      view_history2 = create(:view_history, user: user)
      
      expect(user.view_histories).to include(view_history1, view_history2)
    end
    #it 'ユーザーは複数のいいね(like)を持てること' do
    #  user = create(:user)
    #  1 = create(:, user: user)
    #  2 = create(:, user: user)
    #  
    #  expect(user.s).to include(1, 2)
    #end
  end
end
