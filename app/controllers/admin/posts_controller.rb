class Admin::PostsController < ApplicationController
  before_action :require_login
  before_action :admin_user

  def index
    @posts = Post.includes(:user)
                 .where.not(users: { account_status: ACCOUNT_STATUS_INACTIVE })
                 .order(id: :asc)
                 .page(params[:page]).per(POSTS_PER_PAGE)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:success] = t("flash_message.delete")
    redirect_to admin_posts_path, status: :see_other
  end
end
