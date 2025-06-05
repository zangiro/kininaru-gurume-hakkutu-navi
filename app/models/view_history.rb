class ViewHistory < ApplicationRecord
  belongs_to :user
  belongs_to :post

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :active_users, -> { joins(:user).where.not(users: { account_status: ACCOUNT_STATUS_INACTIVE }) }
end
