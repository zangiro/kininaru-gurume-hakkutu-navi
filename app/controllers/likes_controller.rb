class LikesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user_like_posts = @user.like_posts.all
    @post_path = "4"
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)   # userモデルのlikeメソッド
    redirect_to root_path, success: "@いいねに登録"
  end

  def destroy
    @post = current_user.likes.find_by(post_id: params[:post_id]).post
    current_user.unlike(@post)   # userモデルのunlikeメソッド
    redirect_to users_path, success: "@いいねを解除"
  end
end
