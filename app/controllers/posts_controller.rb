class PostsController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @post = Post.new
    @post.build_dish
    @post.post_genre_tags.build.build_genre_tag
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
    filtered_params = post_params.except(:post_genre_tags_attributes)

    @post = current_user.posts.new(filtered_params)

    @old_tags = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    #oldとnewで分ける必要ないかも
    @new_tags = @old_tags.join(',').split(',').map(&:strip)

    @new_tags.each do |tag_name|
       @post.genre_tags.new(name: tag_name)
    end

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
    params.require(:post).permit(:id, :title, :source, :store_url, dish_attributes: [ :id, :introduction, :description ], post_genre_tags_attributes: [ :id, genre_tag_attributes: [ :id, :name ]])
  end
end
  