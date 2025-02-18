class ViewHistoriesController < ApplicationController
  before_action :require_login, only: %i[index]

  def index
    @view_history_posts = current_user.view_history_posts
    @user = current_user
    @post_path = "5"
  end
end
