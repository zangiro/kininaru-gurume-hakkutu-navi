class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validate :main_image_attached

  belongs_to :user
  has_one :dish, dependent: :destroy
  accepts_nested_attributes_for :dish  # allow_destroy: true

  has_many :post_area_tags, dependent: :destroy
  has_many :area_tags, through: :post_area_tags
  accepts_nested_attributes_for :post_area_tags

  has_many :post_genre_tags, dependent: :destroy
  has_many :genre_tags, through: :post_genre_tags
  accepts_nested_attributes_for :post_genre_tags  # allow_destroy: true

  has_many :post_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :post_taste_tags
  accepts_nested_attributes_for :post_taste_tags

  has_many :post_outher_tags, dependent: :destroy
  has_many :outher_tags, through: :post_outher_tags
  accepts_nested_attributes_for :post_outher_tags

  has_many :post_playlists, dependent: :destroy
  has_many :playlists, through: :post_playlists

  has_one_attached :main_image
  has_one_attached :sub_image_first
  has_one_attached :sub_image_second

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :view_histories, dependent: :destroy

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }

  def main_image_attached
    errors.add(:base, "画像を添付してください") unless main_image.attached?
  end
  # あとでrailsi-18n化したい

  def update_tags(input_tags, tag_type)
    input_tags = input_tags.join(",").split(",").map(&:strip)  # コンマで区切って配列にする。空白削除 +複数の配列を位置行の文字列へ

    old_tags = self.send("#{tag_type}_tags").pluck(:name) unless self.send("#{tag_type}_tags").nil?  # 更新前のタグ配列取得
    delete_tags = old_tags - input_tags  # 削除予定タグ
    new_tags = input_tags - old_tags  # 新しくインスタンス作成予定タグ

    delete_tags.each do |old_tag_name|
      old_tag = self.send("#{tag_type}_tags").find_by(name: old_tag_name)
      self.send("#{tag_type}_tags").delete(old_tag) if old_tag  # 存在する場合だけ削除
    end

    new_tags.uniq.each do |new_tag_name|
      new_tag = "#{tag_type.capitalize}Tag".constantize.find_or_create_by(name: new_tag_name)  # capitalizeで大小文字化。constantizeでrubyクラスとして扱う
      self.send("#{tag_type}_tags") << new_tag unless self.send("#{tag_type}_tags").include?(new_tag) # sendは指定したメソッドをオブジェクト(self)に対して呼び出すためのメソッド
    end
  end

  def self.how_many_posts?(posts_count)
    if posts_count == 0
      18
    elsif posts_count <= 6
      12
    elsif posts_count <= 12
      6
    else
      0
    end
  end
  # 本番は1ページ36枚画像にする。テストはデータ少ないから最大12枚画像にする。

  # def self.how_many_posts?(posts_count)
  #  if posts_count == 0
  #    36
  #  elsif posts_count <= 6
  #    30
  #  elsif posts_count <= 12
  #    24
  #  elsif posts_count <= 18
  #    18
  #  elsif posts_count <= 24
  #    12
  #  elsif posts_count <= 30
  #    6
  #  else
  #    0
  #  end
  # end


  # def post_test(word)
  #  if word == 'latest'
  #    latest
  #  elsif word == 'old'
  #    old
  #  else
  #    nil
  #  end
  # end
  # 記事一覧やタグ検索時の簡略化用メソッド。現在NoMethodErrorで未実装

  def self.ransackable_attributes(auth_object = nil)
    ["title"]  # 検索可能な属性をここに追加
  end

  def self.ransackable_associations(auth_object = nil)
    [ "dish", "area_tags" ]
  end
end
