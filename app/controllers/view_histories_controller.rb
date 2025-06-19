class ViewHistoriesController < ApplicationController
  before_action :require_login, only: %i[index all_view_history_delete]

  def index
    @view_history_posts = current_user.view_history_posts.active_users
                                                         .order("view_histories.created_at DESC")
                                                         .page(params[:page]).per(POSTS_PER_PAGE)
    @user = current_user
    @post_path = VIEW_HISTORY_INDEX_POST_PATH
  end

  def all_view_history_delete
    current_user.view_histories.destroy_all
    redirect_to view_histories_path, success: t("flash_message.delete_view_histories")
  end
end
