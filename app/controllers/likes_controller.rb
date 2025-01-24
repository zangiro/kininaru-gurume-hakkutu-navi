class LikesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user_like_posts = @user.like_posts.all
    @post_path = "4"
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)   # userモデルのlikeメソッド

    # リダイレクトしない際create.turbo_stream.erbが呼ばれる
  end

  def destroy
    @post = current_user.likes.find_by(post_id: params[:post_id]).post
    # @post = current_user.likes.find(params[:post_id]).post
    # board = current_user.bookmarks.find(params[:id]).board
    # @likes = @post.likes
    # @like = @likes.find_by(user_id: @user.id)
    current_user.unlike(@post)   # userモデルのunlikeメソッド

    # リダイレクトしない際destroy.turbo_stream.erbが呼ばれる
  end
end
