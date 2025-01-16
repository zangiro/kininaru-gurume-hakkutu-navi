class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :is_public, inclusion: { in: [ true, false ], message: "@を選んでください" }
  validate :agreement

  #validate :email_present
  #validate :password_present

  has_many :posts, dependent: :destroy
  has_many :playlists, dependent: :destroy
  attr_accessor :agree_terms

  def agreement
    if new_record?
      unless agree_terms == "1" || agree_terms == true
        errors.add(:base, "@利用規約に同意されてません")
      end
    end
  end

  #def email_present
  #  errors.add(:email, "メールアドレスを入力してください") if email.blank?
  #end

  #def password_present
  #  errors.add(:password, "パスワードを入力してください") if password.blank?
  #end
end
