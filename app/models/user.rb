class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: MAXIMUM_INPUT }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: MAXIMUM_INPUT }
  validate :agreement
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true
  # 値が存在するならユニークな値、 もしくは値がない場合ならバリデーションが通る。
  # トークンが必要なときにだけバリデーションを厳しくして、トークンが不要な場合にはエラーが出ないようにするため
  validates :avatar, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }

  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy

  has_many :view_histories, dependent: :destroy
  has_many :view_history_posts, through: :view_histories, source: :post

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_one_attached :avatar

  attr_accessor :agree_terms

  geocoded_by :address
  # addressカラムの内容を緯度・経度に変換する

  after_validation :geocode
  # バリデーションの実行後に変換処理を実行後、latitudeカラム・longitudeカラムに緯度・経度の値が入力される

  def agreement
    if new_record?
      errors.add(:agree_terms, "に同意されてません") unless agree_terms == AGREE_TERMS_SELECTED || agree_terms == true
    end
  end
  # agree_termsのチェックボックスを押すと値が"1"かtrueになる

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

  def admin?
    self.admin
  end

  def decorated
    UserDecorator.new(self)
  end
end
