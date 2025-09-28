class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: MAXIMUM_INPUT }
  validates :main_image, presence: true, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }
  validates :sub_image_first, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }
  validates :sub_image_second, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }

  belongs_to :user
  has_one :dish, dependent: :destroy
  accepts_nested_attributes_for :dish

  has_many :post_area_tags, dependent: :destroy
  has_many :area_tags, through: :post_area_tags
  accepts_nested_attributes_for :post_area_tags

  has_many :post_genre_tags, dependent: :destroy
  has_many :genre_tags, through: :post_genre_tags
  accepts_nested_attributes_for :post_genre_tags

  has_many :post_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :post_taste_tags
  accepts_nested_attributes_for :post_taste_tags

  has_many :post_outher_tags, dependent: :destroy
  has_many :outher_tags, through: :post_outher_tags
  accepts_nested_attributes_for :post_outher_tags

  has_one_attached :main_image
  has_one_attached :sub_image_first
  has_one_attached :sub_image_second

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :view_histories, dependent: :destroy

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :active_users, -> { joins(:user).where.not(users: { account_status: ACCOUNT_STATUS_INACTIVE }) }

  def update_tags(input_tag, tag_type)
    input_tags = input_tag.join(",").split(",").map(&:strip)

    old_tags = self.send("#{tag_type}_tags").pluck(:name) unless self.send("#{tag_type}_tags").nil?
    delete_tags = old_tags - input_tags
    new_tags = input_tags - old_tags

    delete_tags.each do |old_tag_name|
      old_tag = self.send("#{tag_type}_tags").find_by(name: old_tag_name)
      self.send("#{tag_type}_tags").delete(old_tag) if old_tag
    end

    new_tags.uniq.each do |new_tag_name|
      new_tag = "#{tag_type.capitalize}Tag".constantize.find_or_create_by(name: new_tag_name)
      self.send("#{tag_type}_tags") << new_tag unless self.send("#{tag_type}_tags").include?(new_tag)
    end

    # strip: 余分な空白削除
    # send("#{tag_type}_tags"):  "" 内の文字列をテーブルとして扱う
    # capitalize: 先頭文字を大文字化
    # constantize: rubyクラスとして扱う
  end

  def self.recommended_post_count_calculation(posts_count)
    return 24 if posts_count == 0
    return 18 if posts_count <= 6
    return 12 if posts_count <= 12
    return 6 if posts_count <= 18
    return 0 if posts_count <= 24
    0
  end
  # 1ページの最大表示数(24)を基準として
  # 24 - posts_count(取得した記事)の結果をおすすめの枠として表示します。

  def decorated
    PostDecorator.new(self)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "title" ]  # 検索可能な属性をここに追加
  end

  def self.ransackable_associations(auth_object = nil)
    [ "dish", "area_tags", "genre_tags", "taste_tags", "outher_tags" ] # 同時に検索したいテーブルを記す
  end
end
