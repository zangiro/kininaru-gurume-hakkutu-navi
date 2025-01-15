class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy add_to_playlist]

  def new
    @post = Post.new
    @post.build_dish
    @post.post_area_tags.build.build_area_tag
    @post.post_genre_tags.build.build_genre_tag
    @post.post_taste_tags.build.build_taste_tag
    @post.post_outher_tags.build.build_outher_tag
  end

  def index
    @user = User.find(params[:user_id])
    @user_posts = @user.posts.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @playlist = params[:playlist_id] ? Playlist.find(params[:playlist_id]) : []
    if logged_in?
    @user_playlists = current_user.playlists
    end
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []
    if request.referer&.include?(posts_path)
      @post_path = "1"
    elsif request.referer&.include?("playlists/")
      @post_path = "2"
    else
      @post_path = "3"
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @area_tag_name = @post.area_tags.pluck(:name).join(",")
    @genre_tag_name = @post.genre_tags.pluck(:name).join(",")
    @taste_tag_name = @post.taste_tags.pluck(:name).join(",")
    @outher_tag_name = @post.outher_tags.pluck(:name).join(",")
    @user = current_user
  end

  def update
    @user = current_user
    filtered_params = post_params.except(:post_area_tags_attributes, :post_genre_tags_attributes, :post_taste_tags_attributes, :post_outher_tags_attributes)
    @post = current_user.posts.find(params[:id])
    @form_input_area_tag = params[:post][:post_area_tags_attributes].values.map { |tag| tag[:area_tag_attributes][:name] }
    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @form_input_outher_tag = params[:post][:post_outher_tags_attributes].values.map { |tag| tag[:outher_tag_attributes][:name] }

    # if @form_input_area_tag != [ "" ] && @post.images.attached? && @post.update(filtered_params)
    #  @post.update_tags(@form_input_area_tag, "area")
    #  @post.update_tags(@form_input_genre_tag, "genre")
    #  @post.update_tags(@form_input_taste_tag, "taste")
    #  @post.update_tags(@form_input_outher_tag, "outher")
    #  redirect_to user_posts_path(current_user), success: '@更新しました'
    # else
    #  @area_tag_name = @form_input_area_tag
    #  @genre_tag_name = @form_input_genre_tag
    #  @taste_tag_name = @form_input_taste_tag
    #  @outher_tag_name = @form_input_outher_tag
    #  flash.now[:danger] = '@更新に失敗しました'
    #  render :edit, status: :unprocessable_entity
    # end
    redirect_to root_path
  end

  def create
    filtered_params = post_params.except(:post_area_tags_attributes, :post_genre_tags_attributes, :post_taste_tags_attributes, :post_outher_tags_attributes)
    @post = current_user.posts.new(filtered_params)
    @form_input_area_tag = params[:post][:post_area_tags_attributes].values.map { |tag| tag[:area_tag_attributes][:name] }
    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @form_input_outher_tag = params[:post][:post_outher_tags_attributes].values.map { |tag| tag[:outher_tag_attributes][:name] }

    # if @form_input_area_tag != [ "" ] && @post.images.attached? && @post.save
    #  @post.update_tags(@form_input_area_tag, "area")
    #  @post.update_tags(@form_input_genre_tag, "genre")
    #  @post.update_tags(@form_input_taste_tag, "taste")
    #  @post.update_tags(@form_input_outher_tag, "outher")
    #  redirect_to user_posts_path(current_user), success: '@記事の作成をしました'
    # else
    #  @area_tag_name = @form_input_area_tag
    #  @genre_tag_name = @form_input_genre_tag
    #  @taste_tag_name = @form_input_taste_tag
    #  @outher_tag_name = @form_input_outher_tag
    #  flash.now[:danger] = '@記事の作成に失敗しました'
    #  render :new, status: :unprocessable_entity
    # end
    redirect_to root_path
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.images.purge
    post.destroy
    flash[:success] = '@記事を削除しました'
    redirect_to user_posts_path(current_user), status: :see_other
  end

  def add_to_playlist
    @post = Post.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.posts << @post unless @playlist.posts.include?(@post)

    redirect_to root_path, success: '@プレイリストに追加しました'
    # if request.referer&.include?("playlists/")
    # redirect_to new_user_path
    # elsif request.referer&.include?(posts_path)
    # redirect_to post_path(@post)
    # else
    # redirect_to post_path(post, area_tags: @area_tags, genre_tags: @genre_tags, taste_tags: @taste_tags, outher_tags: @outher_tags)
    # end
  end

  private

  def post_params
    params.require(:post).permit(:id, :title, :source, :store_url, :images, dish_attributes: [ :id, :introduction, :description ], post_area_tags_attributes: [ :id, area_tag_attributes: [ :id, :name ] ], post_genre_tags_attributes: [ :id, genre_tag_attributes: [ :id, :name ] ], post_taste_tags_attributes: [ :id, taste_tag_attributes: [ :id, :name ] ], post_outher_tags_attributes: [ :id, outher_tag_attributes: [ :id, :name ] ])
  end
end
