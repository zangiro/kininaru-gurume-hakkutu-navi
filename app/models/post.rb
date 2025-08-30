class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: MAXIMUM_INPUT }
  validates :main_image, presence: true, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }
  validates :sub_image_first, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }
  validates :sub_image_second, blob: { content_type: [ "image/jpg", "image/jpeg", "image/png" ] }

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
    # update時を例にの入力例「"ああ","いい","うう"」 
    # postコントローラーのupdateメソッド実行時、重複して「"ああ","いい","うう","ああ,いい,うう"」となる
    input_tags = input_tag.join(",").split(",").map(&:strip)
    # join後 => "ああ,いい,うう,ああ,いい,うう"
    # split後 => ["ああ", "いい", "うう", "ああ", "いい", "うう"]
    # strip...空白削除   "ああ   " => "ああ"となる。

    old_tags = self.send("#{tag_type}_tags").pluck(:name) unless self.send("#{tag_type}_tags").nil?
    # 現在の対象のタグを確認。　この場合は「"ああ","いい","うう","ああ,いい,うう"」
    # self => この場合は@postのこと
    # send("#{tag_type}_tags") => ""内の文字列をテーブルとして扱う
    delete_tags = old_tags - input_tags
    # 削除予定タグ
    # delete_tags=> ["ああ,いい,うう"]
    new_tags = input_tags - old_tags
    # 新しくインスタンス作成予定タグ

    delete_tags.each do |old_tag_name|
      old_tag = self.send("#{tag_type}_tags").find_by(name: old_tag_name)
      self.send("#{tag_type}_tags").delete(old_tag) if old_tag
      # find_byで対象に削除候補(old_tag_name)があるか確認
      # ifを使い、存在する場合だけ削除
    end

    new_tags.uniq.each do |new_tag_name|
      new_tag = "#{tag_type.capitalize}Tag".constantize.find_or_create_by(name: new_tag_name)
      self.send("#{tag_type}_tags") << new_tag unless self.send("#{tag_type}_tags").include?(new_tag)
      # capitalizeで先頭文字を大文字化。
      # 例...tag_type = "hello"
      # "#{tag_type}_tags" => "HelloTag"
      # constantizeでrubyクラスとして扱う
      # find_or_create_by...対象(new_tag_name)がレコードに存在しない場合のみ新規レコードとして作成
    end
  end

  def self.how_many_posts?(posts_count)
    if posts_count == 0
      24
    elsif posts_count <= 6
      18
    elsif posts_count <= 12
      12
    elsif posts_count <= 18
      6
    elsif posts_count <= 24
      0
    end
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
