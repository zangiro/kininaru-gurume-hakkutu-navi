class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :is_public, inclusion: { in: [ true, false ], message: "@を選んでください" }
  validate :agreement

  has_many :posts, dependent: :destroy
  has_many :playlists, dependent: :destroy
  attr_accessor :agree_terms

  def agreement
    unless agree_terms == "1" || agree_terms == true
      errors.add(:base, "@利用規約に同意されてません")
    end
  end
end
