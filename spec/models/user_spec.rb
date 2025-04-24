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
    # ーーーーーーーーーーーー関連付け確認ーーーーーーーーーーーーー

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

    it 'ユーザーは複数のauthenticationsを持てること' do
      user = create(:user)
      authentication1 = create(:authentication, user: user, provider: 'github', uid: '12345')
      authentication2 = create(:authentication, user: user, provider: 'google', uid: '67890')
      expect(user.authentications.count).to eq(2) # 認証情報の数を確認
      expect(user.authentications).to include(authentication1, authentication2) # 認証情報の存在を確認
    end

    # ーーーーーーーーーーーー関連付け確認ーーーーーーーーーーーーー

    # ーーーーーーーーーーーー削除確認ーーーーーーーーーーーーー

    it 'ユーザーを削除すると記事も削除されるか' do
      user = create(:user)
      post = create(:post, user: user)
      expect { user.destroy }.to change { Post.count }.by(-1)
    end

    it 'ユーザーを削除するといいね(like)も削除されるか' do
      user = create(:user)
      like = create(:like, user: user)
      expect { user.destroy }.to change { Like.count }.by(-1)
    end

    it 'ユーザーを削除するとコメントも削除されるか' do
      user = create(:user)
      comment = create(:comment, user: user)
      expect { user.destroy }.to change { Comment.count }.by(-1)
    end

    it 'ユーザーを削除すると閲覧履歴も削除されるか' do
      user = create(:user)
      view_history = create(:view_history, user: user)
      expect { user.destroy }.to change { ViewHistory.count }.by(-1)
    end

    it 'ユーザーを削除するとauthenticationも削除されるか' do
      user = create(:user)
      authentication = create(:authentication, user: user, provider: 'github', uid: '12345')
      expect { user.destroy }.to change { Authentication.count }.by(-1)
    end

    # ーーーーーーーーーーーー削除確認ーーーーーーーーーーーーー
  end
end
