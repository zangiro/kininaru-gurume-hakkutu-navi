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
    @name = @post.genre_tags.pluck(:name).join(",")
  end

  def update
    filtered_params = post_params.except(:post_genre_tags_attributes)

    @post = current_user.posts.find(params[:id])

    @form_input_tag = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] } #フォームの値をそのまま取得
    @input_tags = @form_input_tag.join(',').split(',').map(&:strip)  #「,」で区切って配列にする
    
    
    @old_tags = @post.genre_tags.pluck(:name) #更新前のタグ配列取得
    @delete_tags = @old_tags - @input_tags #削除予定タグ
    @new_tags = @input_tags - @old_tags #新しくインスタンス作成予定タグ
    


    @delete_tags.each do |old_tag_name|
      old_genre_tag = @post.genre_tags.find_by(name: old_tag_name)
      old_genre_tag.destroy if old_genre_tag # 存在する場合だけ削除
    end

    @new_tags.each do |new_tag_name|
      new_genre_tag = GenreTag.find_or_create_by(name: new_tag_name)
      @post.post_genre_tags.new(genre_tag: new_genre_tag) if new_genre_tag
    end


    if @post.update(filtered_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    filtered_params = post_params.except(:post_genre_tags_attributes)

    @post = current_user.posts.new(filtered_params)

    @old_tags = params[:post][:post_genre_tags_attributes].values.map { |tag| tag[:genre_tag_attributes][:name] }

    @new_tags = @old_tags.join(',').split(',').map(&:strip)

    @new_tags.each do |tag_name|
      genre_tag = GenreTag.find_or_create_by(name: tag_name)
      @post.post_genre_tags.new(genre_tag: genre_tag)
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
  