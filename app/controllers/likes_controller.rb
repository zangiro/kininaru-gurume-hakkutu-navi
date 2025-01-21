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
    #@post = current_user.likes.find(params[:post_id])
    #@post = current_user.likes.find(params[:post_id]).all
    @p0 = Post.find(params[:post_id])
    #@p1 = Post.find(post_id: params[:post_id])
    @p2 = Post.find(params[:id])
    @p3 = current_user.likes
    @p4 = current_user.likes.all
    @p5 = params[:post_id]
    @p6 = params[:id]
    @p7 = current_user.likes.find_by(post_id: params[:post_id])
    @p8 = current_user.likes.find_by(post_id: params[:post_id]).post
    current_user.unlike(@p8)
    #binding.pry
    redirect_to users_path, success: "@222"
  end
end
