class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }

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

  has_many_attached :images

  def update_tags(input_tags, tag_type)
    input_tags = input_tags.join(",").split(",").map(&:strip)  # コンマで区切って配列にする。空白削除 +複数の配列を位置行の文字列へ

    old_tags = self.send("#{tag_type}_tags").pluck(:name) unless self.send("#{tag_type}_tags").nil?  # 更新前のタグ配列取得
    delete_tags = old_tags - input_tags  # 削除予定タグ
    new_tags = input_tags - old_tags  # 新しくインスタンス作成予定タグ

    delete_tags.each do |old_tag_name|
      old_tag = self.send("#{tag_type}_tags").find_by(name: old_tag_name)
      old_tag.destroy if old_tag  # 存在する場合だけ削除
    end

    new_tags.uniq.each do |new_tag_name|
      new_tag = "#{tag_type.capitalize}Tag".constantize.find_or_create_by(name: new_tag_name)  # capitalizeで大小文字化。constantizeでrubyクラスとして扱う
      self.send("#{tag_type}_tags") << new_tag
    end
  end
end
