class LikesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user_like_posts = @user.like_posts.joins(:user)
                                       .where.not(users: { account_status: 1 })
                                       .page(params[:page]).per(24)
    @post_path = "4"
  end

  def create
    @post = Post.find(params[:post_id])
    current_user.like_plus(@post)   # userモデルのlike_plusメソッド
    @like = @post.likes.find_by(user_id: current_user.id)
    # リダイレクトしない際create.turbo_stream.erbが呼ばれる
  end

  def destroy
    @post = current_user.likes.find_by(post_id: params[:post_id]).post
    current_user.like_minus(@post)   # userモデルのlike_minusメソッド
    # リダイレクトしない際destroy.turbo_stream.erbが呼ばれる
  end
end
