class LikesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user_like_posts = @user.like_posts.all
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    redirect_to root_path, success: "@"
  end

  def destroy
    #@board = current_user.bookmarks.find(params[:id]).board
    #current_user.unbookmark(@board)
  end
end
