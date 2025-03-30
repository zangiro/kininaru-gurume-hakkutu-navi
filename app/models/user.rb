class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  # validates :is_public, inclusion: { in: [ true, false ], message: "@を選んでください" }
  # あとでrailsi-18n化したい
  validate :agreement
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true
  # 値が存在するならユニークな値、 もしくは値がない場合ならバリデーションが通る。
  # トークンが必要なときにだけバリデーションを厳しくして、トークンが不要な場合にはエラーが出ないようにするため

  has_many :posts, dependent: :destroy
  has_many :playlists, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy

  has_many :view_histories, dependent: :destroy
  has_many :view_history_posts, through: :view_histories, source: :post

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_one_attached :avatar

  attr_accessor :agree_terms

  def agreement
    if new_record?
      unless agree_terms == "1" || agree_terms == true
        errors.add(:base, "@利用規約に同意されてません")
        #  あとでrailsi-18n化したい
      end
    end
  end

  def like_plus(post)
    like_posts << post
  end

  def like_minus(post)
    like_posts.destroy(post)
  end

  def like_include?(post)
    like_posts.include?(post)
  end

  def view_history_plus(post)
    view_history_posts << post
  end

  def view_history_minus(post)
    view_history_posts.destroy(post)
  end

  def view_history_include?(post)
    view_history_posts.include?(post)
  end

  def own?(object)
    id == object&.user_id
  end
  # current_user.own?(comment)と使い、コメントの作成者がログイン中のユーザーのものか確認してる
end
