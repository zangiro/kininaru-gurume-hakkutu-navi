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

    # -------------ページネーション(gemなし)-----------------

    @max_page = 18
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    # animals_path(page: 1)みたいにしなくてもpageは1になる
    # @eがnilでもnil.to_iは0になる
    @paginate_search_posts = @search_posts.slice((@page - 1) * @max_page, @max_page)
    # @paginate_search_posts は記事情報が入る
    @total_posts = @search_posts.count
    # sizeとcountは動作はにてる
    @total_pages = (@total_posts.to_f / @max_page).ceil

    # ----------------------おすすめ表示--------------------------

    # ページネーションありでも動作確認

    @maximum_number = Post.how_many_posts?(@search_posts.count)

    # モデルを使わないパターン　最大画像数18
    # if @search_posts.count == 0
    #  @maximum_number = 18
    # elsif @search_posts.count <= 6
    #  @maximum_number = 12
    # elsif @search_posts.count <= 12
    #  @maximum_number = 6
    # else
    #  @maximum_number = 0
    # end

    # テスト用の閲覧履歴のデータを使わないで記事を取得するパターン
    # @recommendations = Post.all.limit(@maximum_number)
    if logged_in?
      @all_users_view_histories = ViewHistory.where.not(user_id: current_user.id).order(created_at: :desc).limit(30)
    else
      @all_users_view_histories = ViewHistory.order(created_at: :desc).limit(30)
    end
    @recommendations = Post.joins(:view_histories).where(view_histories: { id: @all_users_view_histories }).group("posts.id").order("COUNT(posts.id) DESC").limit(@maximum_number)
  end
end
