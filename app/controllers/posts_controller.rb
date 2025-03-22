class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy add_to_playlist]

  def new
    @post = Post.new
    @post.build_dish
    @post.post_area_tags.build.build_area_tag
    @post.post_genre_tags.build.build_genre_tag
    @post.post_taste_tags.build.build_taste_tag
    @post.post_outher_tags.build.build_outher_tag

    @area_tag_name = []
    @genre_tag_name = []
    @taste_tag_name = []
    @outher_tag_name = []
  end
# ------------------------------
  def index_test
    @test = "eee"
    @q = Post.ransack(params[:q])
    @tests = @q.result(distinct: true).includes(:user, :dish, :area_tags, :genre_tags, :taste_tags, :outher_tags)
  end
# ------------------------------
  def index
    @user = User.find(params[:user_id])
    if params[:latest]
      @user_posts = @user.posts.all.latest.page(params[:page]).per(5)
    elsif params[:old]
      @user_posts = @user.posts.all.old.page(params[:page]).per(5)
    else
      @user_posts = @user.posts.all.page(params[:page]).per(5)
    end

    # @user_posts = @user.posts.test(params[:latest] ? 'latest' : (params[:old] ? 'old' : nil)).page(params[:page]).per(5)
    # 簡略化用メソッド「post_test」を実装したい。現在NoMethodErrorで未実装

    @post_path = "1"
    # ------------------------------
    @q = Post.ransack(params[:q])
    #@tests = @q.result(distinct: true).includes(:user, :dish)
    # ------------------------------
  end

  def show
    @post = Post.find(params[:id])
    @posted_user = @post.user
    @user = params[:user_id] ? User.find(params[:user_id]) : []
    @playlist = params[:playlist_id] ? Playlist.find(params[:playlist_id]) : []
    @user_playlists = logged_in? ? current_user.playlists : []
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []
    @post_path = params[:post_path]
    @comment = Comment.new
    @post_comments = @post.comments.includes(:user).order(updated_at: :desc).limit(3)

    if logged_in?
      # 閲覧履歴を残す処理
      if current_user.view_history_include?(@post)
        current_user.view_history_minus(@post)
      end
      current_user.view_history_plus(@post)
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
    @main_image = post_params[:main_image]
    @sub_image_first = post_params[:sub_image_first]
    @sub_image_second = post_params[:sub_image_second]

    if post_params[:title].present? && params[:post][:dish_attributes][:description].present? && @form_input_area_tag != [ "" ]
      unless @main_image.nil?
        @post.main_image.purge
      end
      unless @sub_image_first.nil?
        @post.sub_image_first.purge
      end
      unless @sub_image_second.nil?
        @post.sub_image_second.purge
      end
    end

    if @form_input_area_tag != [ "" ] && @post.update(filtered_params)
      @post.update_tags(@form_input_area_tag, "area")
      @post.update_tags(@form_input_genre_tag, "genre")
      @post.update_tags(@form_input_taste_tag, "taste")
      @post.update_tags(@form_input_outher_tag, "outher")
      redirect_to user_posts_path(current_user), success: t("flash_message.update_success")
    else
      @area_tag_name = @form_input_area_tag
      @genre_tag_name = @form_input_genre_tag
      @taste_tag_name = @form_input_taste_tag
      @outher_tag_name = @form_input_outher_tag
      if @form_input_area_tag == [ "" ]
        flash.now[:danger] = t("flash_message.no_tag_entered")
      else
        flash.now[:danger] = t("flash_message.update_failure")
      end
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    filtered_params = post_params.except(:post_area_tags_attributes, :post_genre_tags_attributes, :post_taste_tags_attributes, :post_outher_tags_attributes)
    @post = current_user.posts.new(filtered_params)
    @form_input_area_tag = params[:post][:post_area_tags_attributes].values.map { |tag| tag[:area_tag_attributes][:name] }
    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @form_input_outher_tag = params[:post][:post_outher_tags_attributes].values.map { |tag| tag[:outher_tag_attributes][:name] }

    if @form_input_area_tag != [ "" ] && @post.save
      @post.update_tags(@form_input_area_tag, "area")
      @post.update_tags(@form_input_genre_tag, "genre")
      @post.update_tags(@form_input_taste_tag, "taste")
      @post.update_tags(@form_input_outher_tag, "outher")
      redirect_to user_posts_path(current_user), success: t("flash_message.post_create")
    else
      @area_tag_name = @form_input_area_tag
      @genre_tag_name = @form_input_genre_tag
      @taste_tag_name = @form_input_taste_tag
      @outher_tag_name = @form_input_outher_tag
      if @form_input_area_tag == [ "" ]
        flash.now[:danger] = t("flash_message.no_tag_entered")
      else
        flash.now[:danger] = t("flash_message.post_create_failure")
      end
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.main_image.purge
    post.sub_image_first.purge
    post.sub_image_second.purge
    post.destroy
    flash[:success] = t("flash_message.delete_post")
    redirect_to user_posts_path(current_user), status: :see_other
  end

  def add_to_playlist
    @post = Post.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])
    @playlist.posts << @post unless @playlist.posts.include?(@post)

    redirect_to root_path, success: "@プレイリストに追加しました"
  end

  private

  def post_params
    params.require(:post).permit(:id, :title, :source, :store_url, :main_image, :sub_image_first, :sub_image_second, dish_attributes: [ :id, :introduction, :description ], post_area_tags_attributes: [ :id, area_tag_attributes: [ :id, :name ] ], post_genre_tags_attributes: [ :id, genre_tag_attributes: [ :id, :name ] ], post_taste_tags_attributes: [ :id, taste_tag_attributes: [ :id, :name ] ], post_outher_tags_attributes: [ :id, outher_tag_attributes: [ :id, :name ] ])
  end
end
