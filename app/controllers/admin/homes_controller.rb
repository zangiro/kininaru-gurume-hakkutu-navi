class Admin::HomesController < ApplicationController
  before_action :require_login
  before_action :admin_user

  def top
    @admin_users = User.where(admin: true)
  end
end
