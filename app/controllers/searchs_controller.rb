class SearchsController < ApplicationController
  def index
    @area_tags = params[:area_tags] || []
    @genre_tags = params[:genre_tags] || []
    @taste_tags = params[:taste_tags] || []
    @outher_tags = params[:outher_tags] || []

    @area_posts = Post.joins(:area_tags)
                      .where(area_tags: { name: @area_tags })
                      .active_users
    @genre_posts = Post.joins(:genre_tags)
                       .where(genre_tags: { name: @genre_tags })
                       .active_users
    @taste_posts = Post.joins(:taste_tags)
                       .where(taste_tags: { name: @taste_tags })
                       .active_users
    @outher_posts = Post.joins(:outher_tags)
                        .where(outher_tags: { name: @outher_tags })
                        .active_users

    @post_ids = @area_posts.pluck(:id) + @genre_posts.pluck(:id) + @taste_posts.pluck(:id) + @outher_posts.pluck(:id)

    if params[:latest]
      @search_posts = Post.where(id: @post_ids).latest.page(params[:page]).per(POSTS_PER_PAGE)
    elsif params[:old]
      @search_posts = Post.where(id: @post_ids).old.page(params[:page]).per(POSTS_PER_PAGE)
    else
      @search_posts = Post.where(id: @post_ids).page(params[:page]).per(POSTS_PER_PAGE)
    end

    @post_path = SEARCH_INDEX_POST_PATH

    # ----------------------以下おすすめ表示--------------------------
    @maximum_number = Post.how_many_posts?(@search_posts.count)
    # how_many_posts?は@search_postsの数に応じて変数に数字を代入する。
    # おすすめ表示で使用。ヒット数が少なければおおっきい数字を。多ければ0~少ない数字を返す。

    if logged_in?
      @all_users_view_histories = ViewHistory.active_users
                                             .where.not(user_id: current_user.id)
                                             .latest
                                             .limit(MAXIMUM_VIEW_HISTORY)
    else
      @all_users_view_histories = ViewHistory.active_users
                                             .latest
                                             .limit(MAXIMUM_VIEW_HISTORY)
    end
    # ログインの有無でおすすめとして参照するデータを少し変える。

    @recommendations = Post.joins(:view_histories)
                           .where(view_histories: { id: @all_users_view_histories })
                           .active_users
                           .group("posts.id")
                           .order("COUNT(posts.id) DESC")
                           .limit(@maximum_number)
    # この変数はおすすめ表示で使用。閲覧履歴を参照してより多く閲覧されてるものを、タグ検索のヒット数が一定以下の場合表示する。
  end

  def search_by_form
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
               .active_users
               .page(params[:page])
               .per(POSTS_PER_PAGE)
    @word = params.dig(:q, :title_or_dish_description_or_dish_introduction_or_area_tags_name_or_genre_tags_name_or_taste_tags_name_or_outher_tags_name_cont) || []
    # @word = params[:q][:title_...]の形で直接searchs/search_by_formと入力するとエラー出る
    # .digはネストされたハッシュや配列から値を安全に取得するために使う。
    # この場合「:q」が存在しない場合NoMethodErrorになる。.digを使うと「:q」がnilでもエラーにならない。
    @post_path = SEARCH_BY_FORM_POST_PATH

    # ----------------------以下おすすめ表示--------------------------
    @maximum_number = Post.how_many_posts?(@posts.count)

    if logged_in?
      @all_users_view_histories = ViewHistory.active_users
                                             .where.not(user_id: current_user.id)
                                             .latest
                                             .limit(MAXIMUM_VIEW_HISTORY)
    else
      @all_users_view_histories = ViewHistory.active_users
                                             .latest
                                             .limit(MAXIMUM_VIEW_HISTORY)
    end

    @recommendations = Post.joins(:view_histories)
                           .where(view_histories: { id: @all_users_view_histories })
                           .active_users
                           .group("posts.id")
                           .order("COUNT(posts.id) DESC")
                           .limit(@maximum_number)
  end

  def autocomplete
    @posts = Post.where("title like ?", "%#{params[:q]}%")
                 .active_users
                 .limit(MAXIMUM_AUTOCOMPLATE)
    render partial: "autocomplete"
  end
end
