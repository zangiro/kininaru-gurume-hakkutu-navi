class PostsController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @post = Post.new
    @post.build_dish
  end

  def index
    @posts = Post.all
    @user_posts = current_user.posts.all
  end

  def show
    @post = current_user.posts.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:id, :title, :source, :store_url, dish_attributes: [ :id, :introduction, :description ])
  end
end
