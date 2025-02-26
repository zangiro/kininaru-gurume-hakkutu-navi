class ViewHistoriesController < ApplicationController
  before_action :require_login, only: %i[index all_view_history_delete]

  def index
    @view_history_posts = current_user.view_history_posts.order("view_histories.created_at DESC").page(params[:page]).per(2)
    @user = current_user
    @post_path = "5"
  end

  def all_view_history_delete
    current_user.view_histories.destroy_all
    redirect_to view_histories_path, success: "@閲覧履歴を削除しました"
  end
end
