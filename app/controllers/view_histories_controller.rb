class ViewHistoriesController < ApplicationController
  before_action :require_login, only: %i[index]

  def index
    @view_history_posts = current_user.view_history_posts.joins(:view_histories).order('view_histories.created_at DESC').page(params[:page]).per(2)
    @user = current_user
    @post_path = "5"
  end
end
