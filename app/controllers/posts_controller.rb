class PostsController < ApplicationController
  before_action :require_login, only: %i[new index create edit update destroy]

  def new
    @post = Post.new
    @post.build_dish
    @post.post_area_tags.build.build_area_tag
    @post.post_genre_tags.build.build_genre_tag
    @post.post_taste_tags.build.build_taste_tag
    @post.post_outher_tags.build.build_outher_tag
  end

  def index
    @posts = Post.all
    @user_posts = current_user.posts.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @area_tag_name = @post.area_tags.pluck(:name).join(",")
    @genre_tag_name = @post.genre_tags.pluck(:name).join(",")
    @taste_tag_name = @post.taste_tags.pluck(:name).join(",")
    @outher_tag_name = @post.outher_tags.pluck(:name).join(",")
  end

  def update
    filtered_params = post_params.except(:post_area_tags_attributes, :post_genre_tags_attributes, :post_taste_tags_attributes, :post_outher_tags_attributes)
    @post = current_user.posts.find(params[:id])
    @form_input_area_tag = params[:post][:post_area_tags_attributes].values.map { |tag| tag[:area_tag_attributes][:name] }
    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @form_input_outher_tag = params[:post][:post_outher_tags_attributes].values.map { |tag| tag[:outher_tag_attributes][:name] }

    if @form_input_area_tag != [ "" ] && @post.images.attached? && @post.update(filtered_params)

      #-----------------------------

      @input_area_tags = @form_input_area_tag.join(",").split(",").map(&:strip)

      @old_area_tags = @post.area_tags.pluck(:name) unless @post.area_tags.nil?
      @delete_area_tags = @old_area_tags - @input_area_tags
      @new_area_tags = @input_area_tags - @old_area_tags

      @delete_area_tags.each do |old_area_tag_name|
        old_area_tag = @post.area_tags.find_by(name: old_area_tag_name)
        old_area_tag.destroy if old_area_tag
      end

      @new_area_tags.uniq.each do |new_area_tag_name|
        new_area_tag = AreaTag.find_or_create_by(name: new_area_tag_name)
        @post.area_tags << new_area_tag
      end

      #--------------------------------

      @input_genre_tags = @form_input_genre_tag.join(",").split(",").map(&:strip)  # コンマで区切って配列にする

      @old_genre_tags = @post.genre_tags.pluck(:name) unless @post.genre_tags.nil? # 更新前のタグ配列取得
      @delete_genre_tags = @old_genre_tags - @input_genre_tags # 削除予定タグ
      @new_genre_tags = @input_genre_tags - @old_genre_tags # 新しくインスタンス作成予定タグ

      @delete_genre_tags.each do |old_genre_tag_name|
        old_genre_tag = @post.genre_tags.find_by(name: old_genre_tag_name)
        old_genre_tag.destroy if old_genre_tag # 存在する場合だけ削除
      end

      @new_genre_tags.uniq.each do |new_genre_tag_name|
        new_genre_tag = GenreTag.find_or_create_by(name: new_genre_tag_name)
        @post.genre_tags << new_genre_tag
      end

      #------------------------------

      @input_taste_tags = @form_input_taste_tag.join(",").split(",").map(&:strip)

      @old_taste_tags = @post.taste_tags.pluck(:name) unless @post.taste_tags.nil?
      @delete_taste_tags = @old_taste_tags - @input_taste_tags
      @new_taste_tags = @input_taste_tags - @old_taste_tags

      @delete_taste_tags.each do |old_taste_tag_name|
        old_taste_tag = @post.taste_tags.find_by(name: old_taste_tag_name)
        old_taste_tag.destroy if old_taste_tag
      end

      @new_taste_tags.uniq.each do |new_taste_tag_name|
        new_taste_tag = TasteTag.find_or_create_by(name: new_taste_tag_name)
        @post.taste_tags << new_taste_tag
      end

      #----------------------

      @input_outher_tags = @form_input_outher_tag.join(",").split(",").map(&:strip)

      @old_outher_tags = @post.outher_tags.pluck(:name) unless @post.outher_tags.nil?
      @delete_outher_tags = @old_outher_tags - @input_outher_tags
      @new_outher_tags = @input_outher_tags - @old_outher_tags

      @delete_outher_tags.each do |old_outher_tag_name|
        old_outher_tag = @post.outher_tags.find_by(name: old_outher_tag_name)
        old_outher_tag.destroy if old_outher_tag
      end

      @new_outher_tags.uniq.each do |new_outher_tag_name|
        new_outher_tag = OutherTag.find_or_create_by(name: new_outher_tag_name)
        @post.outher_tags << new_outher_tag
      end

      #-----------------------

      redirect_to posts_path
    else
      @area_tag_name = @form_input_area_tag
      @genre_tag_name = @form_input_genre_tag
      @taste_tag_name = @form_input_taste_tag
      @outher_tag_name = @form_input_outher_tag
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

    if @form_input_area_tag != [ "" ] && @post.images.attached? && @post.save

      #-----------------------------

      @input_area_tags = @form_input_area_tag.join(",").split(",").map(&:strip)

      @old_area_tags = @post.area_tags.pluck(:name) unless @post.area_tags.nil?
      @delete_area_tags = @old_area_tags - @input_area_tags
      @new_area_tags = @input_area_tags - @old_area_tags

      @delete_area_tags.each do |old_area_tag_name|
        old_area_tag = @post.area_tags.find_by(name: old_area_tag_name)
        old_area_tag.destroy if old_area_tag
      end

      @new_area_tags.uniq.each do |new_area_tag_name|
        new_area_tag = AreaTag.find_or_create_by(name: new_area_tag_name)
        @post.area_tags << new_area_tag
      end

      #--------------------------------

      @input_genre_tags = @form_input_genre_tag.join(",").split(",").map(&:strip)  # コンマで区切って配列にする

      @old_genre_tags = @post.genre_tags.pluck(:name) unless @post.genre_tags.nil? # 更新前のタグ配列取得
      @delete_genre_tags = @old_genre_tags - @input_genre_tags # 削除予定タグ
      @new_genre_tags = @input_genre_tags - @old_genre_tags # 新しくインスタンス作成予定タグ

      @delete_genre_tags.each do |old_genre_tag_name|
        old_genre_tag = @post.genre_tags.find_by(name: old_genre_tag_name)
        old_genre_tag.destroy if old_genre_tag # 存在する場合だけ削除
      end

      @new_genre_tags.uniq.each do |new_genre_tag_name|
        new_genre_tag = GenreTag.find_or_create_by(name: new_genre_tag_name)
        @post.genre_tags << new_genre_tag
      end

      #------------------------------

      @input_taste_tags = @form_input_taste_tag.join(",").split(",").map(&:strip)

      @old_taste_tags = @post.taste_tags.pluck(:name) unless @post.taste_tags.nil?
      @delete_taste_tags = @old_taste_tags - @input_taste_tags
      @new_taste_tags = @input_taste_tags - @old_taste_tags

      @delete_taste_tags.each do |old_taste_tag_name|
        old_taste_tag = @post.taste_tags.find_by(name: old_taste_tag_name)
        old_taste_tag.destroy if old_taste_tag
      end

      @new_taste_tags.uniq.each do |new_taste_tag_name|
        new_taste_tag = TasteTag.find_or_create_by(name: new_taste_tag_name)
        @post.taste_tags << new_taste_tag
      end

      #----------------------

      @input_outher_tags = @form_input_outher_tag.join(",").split(",").map(&:strip)

      @old_outher_tags = @post.outher_tags.pluck(:name) unless @post.outher_tags.nil?
      @delete_outher_tags = @old_outher_tags - @input_outher_tags
      @new_outher_tags = @input_outher_tags - @old_outher_tags

      @delete_outher_tags.each do |old_outher_tag_name|
        old_outher_tag = @post.outher_tags.find_by(name: old_outher_tag_name)
        old_outher_tag.destroy if old_outher_tag
      end

      @new_outher_tags.uniq.each do |new_outher_tag_name|
        new_outher_tag = OutherTag.find_or_create_by(name: new_outher_tag_name)
        @post.outher_tags << new_outher_tag
      end

      #-----------------------

      redirect_to posts_path
    else
      @area_tag_name = @form_input_area_tag
      @genre_tag_name = @form_input_genre_tag
      @taste_tag_name = @form_input_taste_tag
      @outher_tag_name = @form_input_outher_tag
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to posts_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:id, :title, :source, :store_url, :images, dish_attributes: [ :id, :introduction, :description ], post_area_tags_attributes: [ :id, area_tag_attributes: [ :id, :name ] ], post_genre_tags_attributes: [ :id, genre_tag_attributes: [ :id, :name ] ], post_taste_tags_attributes: [ :id, taste_tag_attributes: [ :id, :name ] ], post_outher_tags_attributes: [ :id, outher_tag_attributes: [ :id, :name ] ])
  end
end
