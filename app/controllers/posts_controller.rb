class PostsController < ApplicationController
  def new
    @post = Post.new
    @post.build_dish
  end

  def index
    @posts = Post.all
    @user_posts = current_user.posts.all
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :source, :store_url, dish_attributes: [ :introduction, :description ])
  end
end
