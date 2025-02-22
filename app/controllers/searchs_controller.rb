class SearchsController < ApplicationController
  def index
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []

    @area_posts = Post.joins(:area_tags).where(area_tags: { name: @area_tags })
    @genre_posts = Post.joins(:genre_tags).where(genre_tags: { name: @genre_tags })
    @taste_posts = Post.joins(:taste_tags).where(taste_tags: { name: @taste_tags })
    @outher_posts = Post.joins(:outher_tags).where(outher_tags: { name: @outher_tags })

    @search_posts = (@area_posts + @genre_posts + @taste_posts + @outher_posts).uniq
    @post_path = "3"

    #@all_users_view_histories = ViewHistory.where.not(user_id: 1).order(created_at: :desc).limit(30)
    #@recommendations = Post.joins(:view_histories).where(view_histories: { id: @all_users_view_histories }).group('posts.id').order('COUNT(posts.id) DESC').limit(6)

    # ページネーションありでも動作確認
    # 本番は1ページ36枚画像にする。テストはデータ少ないから最大12枚画像にする。

    # if @search_posts.count <= 1
    #   @number = 36
    # elsif @search_posts.count <= 6
    #   @number = 30
    # elsif @search_posts.count <= 12
    #   @number = 24
    # elsif @search_posts.count <= 18
    #   @number = 18
    # elsif @search_posts.count <= 24
    #   @number = 12
    # elsif @search_posts.count <= 30
    #   @number = 6
    # else
    #   @number = 0
    # end
    if @search_posts.count == 0
      @number = 18
    elsif @search_posts.count <= 6
      @number = 12
    elsif @search_posts.count <= 12
      @number = 6
    else
      @number = 0
    end

    #@recommendations = Post.all.limit(@number)
    @all_users_view_histories = ViewHistory.where.not(user_id: 1).order(created_at: :desc).limit(30)
    @recommendations = Post.joins(:view_histories).where(view_histories: { id: @all_users_view_histories }).group('posts.id').order('COUNT(posts.id) DESC').limit(@number)
  end
end
