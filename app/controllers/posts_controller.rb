class PostsController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @post = Post.new
    @post.build_dish
    @post.post_genre_tags.build.build_genre_tag
    @post.post_taste_tags.build.build_taste_tag
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
    @genre_tag_name = @post.genre_tags.pluck(:name).join(",")
    @taste_tag_name = @post.taste_tags.pluck(:name).join(",")
  end

  def update
    filtered_params = post_params.except(:post_genre_tags_attributes, :post_taste_tags_attributes)
    @post = current_user.posts.find(params[:id])

    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] } # フォームの値をそのまま取得
    @input_genre_tags = @form_input_genre_tag.join(",").split(",").map(&:strip)  # コンマで区切って配列にする

    @old_genre_tags = @post.genre_tags.pluck(:name) unless @post.genre_tags.nil? # 更新前のタグ配列取得
    @delete_genre_tags = @old_genre_tags - @input_genre_tags # 削除予定タグ
    @new_genre_tags = @input_genre_tags - @old_genre_tags # 新しくインスタンス作成予定タグ

    @delete_genre_tags.each do |old_genre_tag_name|
      old_genre_tag = @post.genre_tags.find_by(name: old_genre_tag_name)
      old_genre_tag.destroy if old_genre_tag # 存在する場合だけ削除
    end

    @new_genre_tags.each do |new_genre_tag_name|
      new_genre_tag = GenreTag.find_or_create_by(name: new_genre_tag_name)
      @post.post_genre_tags.new(genre_tag: new_genre_tag) if new_genre_tag
    end

    #------------------------------

    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @input_taste_tags = @form_input_taste_tag.join(",").split(",").map(&:strip)

    @old_taste_tags = @post.taste_tags.pluck(:name) unless @post.taste_tags.nil?
    @delete_taste_tags = @old_taste_tags - @input_taste_tags
    @new_taste_tags = @input_taste_tags - @old_taste_tags

    @delete_taste_tags.each do |old_taste_tag_name|
      old_taste_tag = @post.taste_tags.find_by(name: old_taste_tag_name)
      old_taste_tag.destroy if old_taste_tag
    end

    @new_taste_tags.each do |new_taste_tag_name|
      new_taste_tag = TasteTag.find_or_create_by(name: new_taste_tag_name)
      @post.post_taste_tags.new(taste_tag: new_taste_tag) if new_taste_tag
    end

    #----------------------

    if @post.update(filtered_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    filtered_params = post_params.except(:post_genre_tags_attributes, :post_taste_tags_attributes)

    @post = current_user.posts.new(filtered_params)

    @form_input_genre_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }
    @input_genre_tags = @form_input_genre_tag.join(",").split(",").map(&:strip)

    @old_genre_tags = @post.genre_tags.pluck(:name) unless @post.genre_tags.nil?
    @delete_genre_tags = @old_genre_tags - @input_genre_tags
    @new_genre_tags = @input_genre_tags - @old_genre_tags

    @delete_genre_tags.each do |old_genre_tag_name|
      old_genre_tag = @post.genre_tags.find_by(name: old_genre_tag_name)
      old_genre_tag.destroy if old_genre_tag
    end

    @new_genre_tags.each do |new_genre_tag_name|
      new_genre_tag = GenreTag.find_or_create_by(name: new_genre_tag_name)
      @post.post_genre_tags.new(genre_tag: new_genre_tag) if new_genre_tag
    end

    #--------------------

    @form_input_taste_tag = params[:post][:post_taste_tags_attributes].values.map { |tag| tag[:taste_tag_attributes][:name] }
    @input_taste_tags = @form_input_taste_tag.join(",").split(",").map(&:strip)

    @old_taste_tags = @post.taste_tags.pluck(:name) unless @post.taste_tags.nil?
    @delete_taste_tags = @old_taste_tags - @input_taste_tags
    @new_taste_tags = @input_taste_tags - @old_taste_tags

    @delete_taste_tags.each do |old_taste_tag_name|
      old_taste_tag = @post.taste_tags.find_by(name: old_taste_tag_name)
      old_taste_tag.destroy if old_taste_tag
    end

    @new_taste_tags.each do |new_taste_tag_name|
      new_taste_tag = TasteTag.find_or_create_by(name: new_taste_tag_name)
      @post.post_taste_tags.new(taste_tag: new_taste_tag) if new_taste_tag
    end

    #----------------------

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
    params.require(:post).permit(:id, :title, :source, :store_url, dish_attributes: [ :id, :introduction, :description ], post_genre_tags_attributes: [ :id, genre_tag_attributes: [ :id, :name ] ], post_taste_tags_attributes: [ :id, taste_tag_attributes: [ :id, :name ] ])
  end
end
